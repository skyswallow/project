class Activity < ActiveRecord::Base

  has_many :activity_applies, :dependent => :destroy

  named_scope :all_order_by_created_at_desc, :order => "created_at desc"
  named_scope :normal, :conditions => "status = '1'"

  def self.upload_activity_photo(path)
    if !path.blank?
      @filename = "#{rand Time.now.to_i}" + "." + path.original_filename.split('.').reverse[0]
      File.open("#{File.expand_path(RAILS_ROOT)}/public/uploads/activities/#{@filename}", "wb") do |f|
        f.write(path.read)
      end
      @filename
    end
  end
  
end
