module Entity
  def self.included(base)
    base.instance_eval do
      belongs_to :user
      default_scope order('id asc')
      base.extend(ClassMethods)
    end
  end

  module ClassMethods
    def with_tags
      where("array_length(akeys(tags), 1) > 0")
    end
  end
end