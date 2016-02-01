class Visitor < ActiveRecord::Base
  has_no_table

  attr_accessor :email, :string
  attr_accessor :first_name, :string
  attr_accessor :last_name, :string

  validates_presence_of :email, :first_name, :last_name
  validates_format_of :email, :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i

  def subscribe
    mailchimp = Gibbon::Request.new(api_key: Rails.application.secrets.MAILCHIMP_API_KEY)
    result = mailchimp.lists("841ace3bb6").members.create(body: {
      email_address: self.email,
      status: "subscribed",
      merge_fields: {FNAME: self.first_name, LNAME: self.last_name}
      })

      Rails.logger.info("Subscribed #{self.email} to Mailchimp") if result
  end
end
