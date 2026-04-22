Rails.application.routes.draw do
  resources :landing_pages
  resources :dashboards
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "landing_pages#index"
end

# # ═══════════════════════════════════════════════════════════════
# # VINYLCTRL — Rails Scaffold
# # Gig booking platform: DJs, Artists, Venues, Event Organizers
# # ═══════════════════════════════════════════════════════════════


# # ── config/routes.rb ────────────────────────────────────────────

# Rails.application.routes.draw do
#   root "pages#home"

#   get "/how-it-works", to: "pages#how",      as: :how_it_works
#   get "/features",     to: "pages#features",  as: :features
#   get "/about",        to: "pages#about",     as: :about
#   get "/contact",      to: "pages#contact",   as: :contact
#   get "/privacy",      to: "pages#privacy",   as: :privacy
#   get "/terms",        to: "pages#terms",     as: :terms

#   # Auth (Devise)
#   devise_for :users, controllers: {
#     registrations: "users/registrations",
#     sessions:      "users/sessions"
#   }

#   # Waitlist
#   resources :waitlist_entries, only: [:create]

#   # Public talent marketplace
#   get "/browse",        to: "profiles#index",  as: :browse
#   resources :profiles,  only: [:show],         param: :slug

#   # Dashboard
#   namespace :dashboard do
#     root "overview#index"
#     resource  :overview,     only: [:show]
#     resources :bookings do
#       member do
#         patch :confirm
#         patch :decline
#         patch :cancel
#         patch :complete
#         post  :send_contract
#       end
#       collection { get :calendar }
#     end
#     resources :gigs,           only: [:index, :show, :create, :destroy] do
#       member { post :apply }
#     end
#     resources :messages, only: [:index, :show, :create]
#     resources :contracts, only: [:index, :show, :create, :update] do
#       member { post :sign }
#     end
#     resources :invoices do
#       member { post :send_invoice; post :mark_paid }
#     end
#     resource  :profile,       only: [:show, :edit, :update]
#     resource  :availability,  only: [:show, :update]
#     resource  :analytics,     only: [:show]
#     resources :notifications, only: [:index] do
#       collection { post :mark_all_read }
#     end
#   end

#   # API (for mobile app or JS)
#   namespace :api do
#     namespace :v1 do
#       resources :profiles,  only: [:index, :show]
#       resources :bookings,  only: [:index, :show, :create, :update]
#       resources :gigs,      only: [:index, :show]
#       resources :messages,  only: [:index, :create]
#     end
#   end
# end


# # ── app/models/user.rb ──────────────────────────────────────────

# class User < ApplicationRecord
#   devise :database_authenticatable, :registerable,
#          :recoverable, :rememberable, :validatable,
#          :confirmable, :trackable

#   USER_TYPES = %w[dj artist venue organizer].freeze

#   has_one  :profile, dependent: :destroy
#   has_many :bookings_as_talent,  class_name: "Booking", foreign_key: :talent_id
#   has_many :bookings_as_client,  class_name: "Booking", foreign_key: :client_id
#   has_many :sent_messages,       class_name: "Message", foreign_key: :sender_id
#   has_many :received_messages,   class_name: "Message", foreign_key: :recipient_id
#   has_many :notifications
#   has_many :gig_applications
#   has_many :contracts,  foreign_key: :talent_id
#   has_many :invoices,   foreign_key: :issuer_id

#   validates :user_type, inclusion: { in: USER_TYPES }
#   validates :first_name, :last_name, presence: true

#   after_create :create_default_profile

#   scope :djs,        -> { where(user_type: "dj") }
#   scope :artists,    -> { where(user_type: "artist") }
#   scope :venues,     -> { where(user_type: "venue") }
#   scope :organizers, -> { where(user_type: "organizer") }

#   def full_name    = "#{first_name} #{last_name}"
#   def initials     = "#{first_name[0]}#{last_name[0]}".upcase
#   def dj?          = user_type == "dj"
#   def artist?      = user_type == "artist"
#   def venue?       = user_type == "venue"
#   def organizer?   = user_type == "organizer"
#   def talent?      = dj? || artist?
#   def hirer?       = venue? || organizer?

#   def all_bookings
#     talent? ? bookings_as_talent : bookings_as_client
#   end

#   private

#   def create_default_profile
#     create_profile!(user: self, slug: generate_slug)
#   end

#   def generate_slug
#     base = "#{first_name}-#{last_name}".downcase.gsub(/[^a-z0-9-]/, "-")
#     Profile.exists?(slug: base) ? "#{base}-#{SecureRandom.hex(3)}" : base
#   end
# end


# # ── db/migrate/XXXXXX_create_users.rb ───────────────────────────

# class CreateUsers < ActiveRecord::Migration[7.1]
#   def change
#     # Devise creates its own users table — add these custom columns:
#     add_column :users, :first_name,   :string, null: false, default: ""
#     add_column :users, :last_name,    :string, null: false, default: ""
#     add_column :users, :user_type,    :string, null: false, default: "dj"
#     add_column :users, :phone,        :string
#     add_column :users, :city,         :string
#     add_column :users, :state,        :string
#     add_column :users, :plan,         :string, default: "free"
#     add_index  :users, :user_type
#   end
# end


# # ── app/models/profile.rb ───────────────────────────────────────

# class Profile < ApplicationRecord
#   belongs_to :user
#   has_many_attached :photos
#   has_one_attached  :avatar

#   has_many :reviews, as: :reviewable
#   has_many :availabilities

#   validates :slug, uniqueness: true, presence: true

#   scope :published,   -> { where(published: true) }
#   scope :by_type,     ->(t)  { joins(:user).where(users: { user_type: t }) if t.present? }
#   scope :by_genre,    ->(g)  { where("? = ANY(genres)", g) if g.present? }
#   scope :by_city,     ->(c)  { joins(:user).where("users.city ILIKE ?", "%#{c}%") if c.present? }
#   scope :by_rate_max, ->(r)  { where("hourly_rate <= ?", r.to_i) if r.present? }
#   scope :available,   -> { where(available: true) }
#   scope :top_rated,   -> { order(average_rating: :desc) }
#   scope :featured,    -> { where(featured: true) }

#   GENRES = %w[
#     hip-hop house afrobeats r&b soul reggaeton
#     trap edm top-40 latin dancehall techno pop jazz
#   ].freeze

#   def display_name  = bio_name.presence || user.full_name
#   def location      = [user.city, user.state].compact.join(", ")
#   def rate_display  = hourly_rate ? "$#{hourly_rate}/hr" : "Contact for rates"
#   def to_param      = slug

#   def average_rating
#     return 0 if reviews.empty?
#     reviews.average(:rating).to_f.round(1)
#   end

#   def review_count = reviews.count
# end


# # ── db/migrate/XXXXXX_create_profiles.rb ─────────────────────────

# class CreateProfiles < ActiveRecord::Migration[7.1]
#   def change
#     create_table :profiles do |t|
#       t.belongs_to :user,      null: false, foreign_key: true
#       t.string     :slug,      null: false
#       t.string     :bio_name
#       t.text       :bio
#       t.string     :tagline
#       t.integer    :hourly_rate
#       t.string     :genres,    array: true, default: []
#       t.string     :equipment
#       t.string     :website
#       t.string     :instagram
#       t.string     :soundcloud
#       t.string     :youtube
#       t.boolean    :published,  default: false
#       t.boolean    :available,  default: true
#       t.boolean    :featured,   default: false
#       t.float      :average_rating, default: 0.0
#       t.integer    :total_bookings,  default: 0
#       t.jsonb      :settings,   default: {}

#       t.timestamps
#     end

#     add_index :profiles, :slug,           unique: true
#     add_index :profiles, :published
#     add_index :profiles, :available
#     add_index :profiles, :genres,         using: :gin
#     add_index :profiles, :average_rating
#   end
# end


# # ── app/models/booking.rb ────────────────────────────────────────

# class Booking < ApplicationRecord
#   STATUSES = %w[pending confirmed declined cancelled completed no_show].freeze

#   belongs_to :talent, class_name: "User"
#   belongs_to :client, class_name: "User"
#   has_one    :contract, dependent: :destroy
#   has_one    :invoice,  dependent: :destroy
#   has_many   :messages, as: :context

#   validates :status,       inclusion: { in: STATUSES }
#   validates :event_date,   presence: true
#   validates :start_time,   presence: true
#   validates :venue_name,   presence: true
#   validates :agreed_rate,  numericality: { greater_than: 0 }, allow_nil: true

#   scope :upcoming,   -> { where("event_date >= ?", Date.today).order(:event_date) }
#   scope :past,       -> { where("event_date < ?",  Date.today).order(event_date: :desc) }
#   scope :pending,    -> { where(status: "pending") }
#   scope :confirmed,  -> { where(status: "confirmed") }
#   scope :for_user,   ->(u) { where(talent: u).or(where(client: u)) }
#   scope :this_month, -> { where(event_date: Time.current.beginning_of_month..Time.current.end_of_month) }

#   before_validation :set_defaults
#   after_create      :send_notifications
#   after_update      :handle_status_change, if: :saved_change_to_status?

#   def duration_hours
#     return nil unless start_time && end_time
#     ((end_time - start_time) / 3600.0).round(1)
#   end

#   def confirm!   = update!(status: "confirmed")
#   def decline!   = update!(status: "declined")
#   def cancel!    = update!(status: "cancelled")
#   def complete!  = update!(status: "completed")

#   def status_color
#     { "pending" => "warning", "confirmed" => "success",
#       "declined" => "danger",  "cancelled" => "danger",
#       "completed" => "muted" }.fetch(status, "muted")
#   end

#   def reference = "VC-#{id.to_s.rjust(6,"0")}"

#   private

#   def set_defaults
#     self.status ||= "pending"
#   end

#   def send_notifications
#     BookingMailer.request_received(self).deliver_later
#     BookingMailer.new_booking_alert(self).deliver_later
#     Notification.create!(user: talent, message: "New booking request from #{client.full_name}", link: "/dashboard/bookings/#{id}")
#   end

#   def handle_status_change
#     BookingMailer.status_update(self).deliver_later
#   end
# end


# # ── db/migrate/XXXXXX_create_bookings.rb ─────────────────────────

# class CreateBookings < ActiveRecord::Migration[7.1]
#   def change
#     create_table :bookings do |t|
#       t.belongs_to :talent,      null: false, foreign_key: { to_table: :users }
#       t.belongs_to :client,      null: false, foreign_key: { to_table: :users }
#       t.string     :status,      null: false, default: "pending"
#       t.string     :venue_name,  null: false
#       t.string     :venue_address
#       t.date       :event_date,  null: false
#       t.time       :start_time
#       t.time       :end_time
#       t.string     :event_type                # birthday, club night, corporate, festival
#       t.string     :genre
#       t.decimal    :agreed_rate, precision: 10, scale: 2
#       t.text       :notes
#       t.text       :client_notes
#       t.string     :reference
#       t.boolean    :contract_signed, default: false
#       t.boolean    :invoice_paid,    default: false

#       t.timestamps
#     end

#     add_index :bookings, :status
#     add_index :bookings, :event_date
#     add_index :bookings, [:talent_id, :event_date]
#     add_index :bookings, [:client_id, :event_date]
#   end
# end


# # ── app/models/gig.rb ────────────────────────────────────────────

# class Gig < ApplicationRecord
#   belongs_to :posted_by, class_name: "User"
#   has_many   :gig_applications
#   has_many   :applicants, through: :gig_applications, source: :user

#   validates :title, :event_date, :venue_name, :budget, presence: true
#   validates :genres, length: { minimum: 1 }

#   scope :open,       -> { where(status: "open") }
#   scope :upcoming,   -> { where("event_date >= ?", Date.today) }
#   scope :by_genre,   ->(g) { where("? = ANY(genres)", g) if g.present? }
#   scope :featured,   -> { where(featured: true) }
#   scope :recent,     -> { order(created_at: :desc) }

#   def applied_by?(user) = gig_applications.exists?(user: user)
#   def deadline_passed?  = application_deadline.present? && application_deadline < Date.today
# end


# # ── db/migrate/XXXXXX_create_gigs.rb ─────────────────────────────

# class CreateGigs < ActiveRecord::Migration[7.1]
#   def change
#     create_table :gigs do |t|
#       t.belongs_to :posted_by,  null: false, foreign_key: { to_table: :users }
#       t.string     :title,      null: false
#       t.text       :description
#       t.string     :venue_name
#       t.string     :venue_city
#       t.string     :venue_state
#       t.date       :event_date
#       t.time       :start_time
#       t.time       :end_time
#       t.string     :genres,     array: true, default: []
#       t.decimal    :budget,     precision: 10, scale: 2
#       t.string     :status,     default: "open"
#       t.date       :application_deadline
#       t.boolean    :featured,   default: false
#       t.integer    :views_count, default: 0

#       t.timestamps
#     end

#     add_index :gigs, :status
#     add_index :gigs, :event_date
#     add_index :gigs, :genres, using: :gin
#   end
# end


# # ── app/models/contract.rb ───────────────────────────────────────

# class Contract < ApplicationRecord
#   belongs_to :booking
#   belongs_to :talent, class_name: "User"
#   belongs_to :client, class_name: "User"

#   scope :unsigned, -> { where(signed_at: nil) }
#   scope :signed,   -> { where.not(signed_at: nil) }

#   def signed?   = signed_at.present?
#   def pending?  = !signed?

#   def sign!(user)
#     update!(signed_at: Time.current, signed_by: user.id)
#     booking.update!(contract_signed: true)
#     ContractMailer.signed(self).deliver_later
#   end
# end


# # ── app/models/invoice.rb ────────────────────────────────────────

# class Invoice < ApplicationRecord
#   belongs_to :booking
#   belongs_to :issuer, class_name: "User"
#   belongs_to :recipient, class_name: "User"

#   STATUSES = %w[draft sent paid overdue cancelled].freeze
#   validates :status, inclusion: { in: STATUSES }

#   scope :paid,    -> { where(status: "paid") }
#   scope :unpaid,  -> { where.not(status: "paid") }
#   scope :overdue, -> { where(status: "overdue") }

#   def number = "INV-#{id.to_s.rjust(5,"0")}"
#   def paid?  = status == "paid"

#   def mark_paid!(method: nil)
#     update!(status: "paid", paid_at: Time.current, payment_method: method)
#     booking.update!(invoice_paid: true)
#   end
# end


# # ── app/controllers/dashboard/overview_controller.rb ─────────────

# class Dashboard::OverviewController < Dashboard::BaseController
#   def show
#     @user = current_user
#     @upcoming_bookings  = @user.all_bookings.confirmed.upcoming.limit(5)
#     @pending_bookings   = @user.all_bookings.pending.count
#     @new_messages       = current_user.received_messages.unread.count
#     @gig_matches        = Gig.open.upcoming.by_genre(current_user.profile&.genres).limit(5) if current_user.talent?

#     # Earnings (current month)
#     @monthly_earnings   = current_user.bookings_as_talent.completed.this_month
#                             .sum(:agreed_rate) if current_user.talent?

#     # Chart data (last 6 months)
#     @earnings_chart = (5.downto(0)).map do |n|
#       month = n.months.ago
#       {
#         label: month.strftime("%b"),
#         value: current_user.bookings_as_talent
#           .where(event_date: month.beginning_of_month..month.end_of_month, status: "completed")
#           .sum(:agreed_rate).to_i
#       }
#     end
#   end
# end


# # ── app/controllers/dashboard/bookings_controller.rb ────────────

# class Dashboard::BookingsController < Dashboard::BaseController
#   before_action :set_booking, only: [:show, :confirm, :decline, :cancel, :complete, :send_contract]

#   def index
#     @bookings = current_user.all_bookings
#                   .order(event_date: :asc)
#                   .then { filter_by_status(_1) }

#     respond_to do |format|
#       format.html
#       format.turbo_stream
#     end
#   end

#   def calendar
#     @bookings = current_user.all_bookings
#                   .where(event_date: params[:start_date]..params[:end_date])
#                   .confirmed
#     render json: @bookings.map { |b| {
#       id:    b.id,
#       title: b.venue_name,
#       start: b.event_date,
#       color: "#C8FF00"
#     }}
#   end

#   def create
#     @booking = Booking.new(booking_params.merge(
#       talent_id: resolve_talent,
#       client_id: current_user.id
#     ))
#     if @booking.save
#       respond_to do |format|
#         format.turbo_stream { render turbo_stream: turbo_stream.update("booking_list", partial: "bookings/list", locals: { bookings: current_user.all_bookings.upcoming }) }
#         format.html         { redirect_to dashboard_booking_path(@booking), notice: "Booking request sent!" }
#       end
#     else
#       render :new, status: :unprocessable_entity
#     end
#   end

#   def confirm  = @booking.confirm!  && respond_with_update
#   def decline  = @booking.decline!  && respond_with_update
#   def cancel   = @booking.cancel!   && respond_with_update
#   def complete = @booking.complete! && respond_with_update

#   def send_contract
#     contract = @booking.create_contract!(
#       talent: @booking.talent,
#       client: @booking.client,
#       terms:  ContractTemplate.generate_for(@booking)
#     )
#     ContractMailer.send_for_signature(contract).deliver_later
#     redirect_to dashboard_booking_path(@booking), notice: "Contract sent for signature."
#   end

#   private

#   def set_booking
#     @booking = current_user.all_bookings.find(params[:id])
#   end

#   def booking_params
#     params.require(:booking).permit(
#       :venue_name, :venue_address, :event_date, :start_time, :end_time,
#       :event_type, :genre, :agreed_rate, :notes, :talent_id
#     )
#   end

#   def resolve_talent
#     params[:booking][:talent_id] || (current_user.talent? ? current_user.id : nil)
#   end

#   def respond_with_update
#     respond_to do |format|
#       format.turbo_stream { render turbo_stream: turbo_stream.replace("booking_#{@booking.id}", partial: "bookings/row", locals: { booking: @booking }) }
#       format.html         { redirect_to dashboard_bookings_path, notice: "Booking updated." }
#     end
#   end

#   def filter_by_status(scope)
#     return scope unless params[:status].present?
#     scope.where(status: params[:status])
#   end
# end


# # ── app/controllers/profiles_controller.rb ──────────────────────

# class ProfilesController < ApplicationController
#   def index
#     @profiles = Profile.published.available
#     @profiles = @profiles.by_type(params[:type])     if params[:type]
#     @profiles = @profiles.by_genre(params[:genre])   if params[:genre]
#     @profiles = @profiles.by_city(params[:city])     if params[:city]
#     @profiles = @profiles.by_rate_max(params[:max_rate]) if params[:max_rate]
#     @profiles = @profiles.top_rated.page(params[:page]).per(20)
#     @genres   = Profile::GENRES
#   end

#   def show
#     @profile  = Profile.published.find_by!(slug: params[:slug])
#     @reviews  = @profile.reviews.order(created_at: :desc).limit(10)
#     @booking  = Booking.new if user_signed_in?
#     @profile.increment!(:view_count)
#   end
# end


# # ── app/models/waitlist_entry.rb ─────────────────────────────────

# class WaitlistEntry < ApplicationRecord
#   validates :email, presence: true, uniqueness: true,
#                     format: { with: URI::MailTo::EMAIL_REGEXP }
#   validates :user_type, inclusion: { in: User::USER_TYPES + ["any"] }, allow_blank: true

#   after_create :send_confirmation

#   private

#   def send_confirmation
#     WaitlistMailer.confirmation(self).deliver_later
#   end
# end


# # ── db/seeds.rb ──────────────────────────────────────────────────

# puts "🎵 Seeding VinylCTRL..."

# # Sample users
# [
#   { first_name: "Marcus", last_name: "Webb",    email: "marcus@vinylctrl.test",  user_type: "dj",       city: "Atlanta",  state: "GA" },
#   { first_name: "Kezia",  last_name: "Amara",   email: "kezia@vinylctrl.test",   user_type: "artist",   city: "Miami",    state: "FL" },
#   { first_name: "Maya",   last_name: "Torres",  email: "maya@vinylctrl.test",    user_type: "venue",    city: "Miami",    state: "FL" },
#   { first_name: "Devon",  last_name: "Charles", email: "devon@vinylctrl.test",   user_type: "organizer",city: "Houston",  state: "TX" },
#   { first_name: "Nova",   last_name: "Sound",   email: "nova@vinylctrl.test",    user_type: "dj",       city: "New York", state: "NY" },
# ].each do |attrs|
#   user = User.find_or_create_by(email: attrs[:email]) do |u|
#     u.assign_attributes(attrs.merge(password: "password123", password_confirmation: "password123"))
#   end
#   user.profile&.update!(
#     published:   true,
#     available:   true,
#     hourly_rate: [300, 350, 400, 500, 600].sample,
#     genres:      Profile::GENRES.sample(3),
#     bio:         "Professional #{attrs[:user_type]} based in #{attrs[:city]}, #{attrs[:state]}.",
#     tagline:     "Let the music speak."
#   )
#   print "."
# end

# puts "\n✅ #{User.count} users seeded."
# puts "🎵 VinylCTRL is ready to CTRL!"

