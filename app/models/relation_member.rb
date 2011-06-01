class RelationMember < ActiveRecord::Base

  belongs_to :relation

#   def after_find
#     self[:member_class] = self.member_type.classify
#   end
# 
#   def after_initialize
#     self[:member_class] = self.member_type.classify unless self.member_type.nil?
#   end
# 
#   def before_save
#     self.member_type = self[:member_class].classify
#   end
# 
#   def member_type=(type)
#     self[:member_type] = type
#     self[:member_class] = type.capitalize
#   end
end
