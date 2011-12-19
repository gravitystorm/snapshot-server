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

    def status_changed
      where("status is not null and status != ?", default_status)
    end

    def percentage_status_changed
      if self.count > 0
        ((self.with_tags.status_changed.count.to_f / self.with_tags.count) * 100).to_i
      else
        0
      end
    end
  end

  def tags_string
    tags.map {|k,v| "#{k}=#{v}"}.join(", ")
  end
end