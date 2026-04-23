# # ── app/controllers/dashboard/bookings_controller.rb ────────────

class Dashboard::BookingsController < Dashboard::BaseController
  before_action :set_booking, only: [:show, :confirm, :decline, :cancel, :complete, :send_contract]

  def index
    @bookings = current_user.all_bookings
                  .order(event_date: :asc)
                  .then { filter_by_status(_1) }

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def calendar
    @bookings = current_user.all_bookings
                  .where(event_date: params[:start_date]..params[:end_date])
                  .confirmed
    render json: @bookings.map { |b| {
      id:    b.id,
      title: b.venue_name,
      start: b.event_date,
      color: "#C8FF00"
    }}
  end

  def create
    @booking = Booking.new(booking_params.merge(
      talent_id: resolve_talent,
      client_id: current_user.id
    ))
    if @booking.save
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update("booking_list", partial: "bookings/list", locals: { bookings: current_user.all_bookings.upcoming }) }
        format.html         { redirect_to dashboard_booking_path(@booking), notice: "Booking request sent!" }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def confirm  = @booking.confirm!  && respond_with_update
  def decline  = @booking.decline!  && respond_with_update
  def cancel   = @booking.cancel!   && respond_with_update
  def complete = @booking.complete! && respond_with_update

  def send_contract
    contract = @booking.create_contract!(
      talent: @booking.talent,
      client: @booking.client,
      terms:  ContractTemplate.generate_for(@booking)
    )
    ContractMailer.send_for_signature(contract).deliver_later
    redirect_to dashboard_booking_path(@booking), notice: "Contract sent for signature."
  end

  private

  def set_booking
    @booking = current_user.all_bookings.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(
      :venue_name, :venue_address, :event_date, :start_time, :end_time,
      :event_type, :genre, :agreed_rate, :notes, :talent_id
    )
  end

  def resolve_talent
    params[:booking][:talent_id] || (current_user.talent? ? current_user.id : nil)
  end

  def respond_with_update
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("booking_#{@booking.id}", partial: "bookings/row", locals: { booking: @booking }) }
      format.html         { redirect_to dashboard_bookings_path, notice: "Booking updated." }
    end
  end

  def filter_by_status(scope)
    return scope unless params[:status].present?
    scope.where(status: params[:status])
  end
end