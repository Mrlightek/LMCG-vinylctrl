# # ── app/controllers/dashboard/overview_controller.rb ─────────────

class Dashboard::OverviewController < Dashboard::BaseController
  def show
    @user = current_user
    @upcoming_bookings  = @user.all_bookings.confirmed.upcoming.limit(5)
    @pending_bookings   = @user.all_bookings.pending.count
    @new_messages       = current_user.received_messages.unread.count
    @gig_matches        = Gig.open.upcoming.by_genre(current_user.profile&.genres).limit(5) if current_user.talent?

    # Earnings (current month)
    @monthly_earnings   = current_user.bookings_as_talent.completed.this_month
                            .sum(:agreed_rate) if current_user.talent?

    # Chart data (last 6 months)
    @earnings_chart = (5.downto(0)).map do |n|
      month = n.months.ago
      {
        label: month.strftime("%b"),
        value: current_user.bookings_as_talent
          .where(event_date: month.beginning_of_month..month.end_of_month, status: "completed")
          .sum(:agreed_rate).to_i
      }
    end
  end
end