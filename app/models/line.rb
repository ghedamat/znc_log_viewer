class Line < ActiveRecord::Base
  include PgSearch

  belongs_to :channel

  scope :ascending, -> { order('timestamp asc') }
  scope :descending, -> { order('timestamp desc') }

  pg_search_scope :search_message,
    :against => [:username, :message],
    :using => [:tsearch,:trigram]

  def self.messages
    where("action = 'message'")
  end

end
