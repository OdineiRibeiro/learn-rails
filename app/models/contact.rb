class Contact < ActiveRecord::Base
  has_no_table
  
  attr_accessor :name, :string
  attr_accessor :email, :string
  attr_accessor :content, :string

  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :content

  validates_format_of :email,
    :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i

  validates_length_of :content, :maximum => 500

  def update_spreadsheet

    session = GoogleDrive.saved_session("config.json")
    ss = session.spreadsheet_by_title('Learn-Rails-Example')

    if ss.nil?
      ss = session.create_spreadsheet('Learn-Rails-Example')
    end

    ws = ss.worksheets[0]
    last_row = 1 + ws.num_rows
    ws[last_row, 1] = Time.new
    ws[last_row, 2] = self.name
    ws[last_row, 3] = self.email
    ws[last_row, 4] = self.content
    ws.save

  end

end
