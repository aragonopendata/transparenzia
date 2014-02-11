module Refinery
  module Members
    class Member < Refinery::Core::BaseModel
      self.table_name = 'refinery_members'

      attr_accessible :name, :current_position, :biography, :previous_position, :notes, :photo_id, :position

      validates :name, :presence => true, :uniqueness => true
    end
  end
end
