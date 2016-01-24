class LeadImport < ActiveRecord::Base
  validates :file, presence: true, uniqueness: true
  def lines
    File.readlines(file)
  end
end
