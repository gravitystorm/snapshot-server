module ApplicationHelper

  def status_label(entity)
    default = case entity.class.name
      when "ProjectNode" then NODE_STATUS_DEFAULT
      when "ProjectWay" then WAY_STATUS_DEFAULT
      when "ProjectRelation" then RELATION_STATUS_DEFAULT
      else ""
    end

    if entity.status? && (entity.status != default)
      content_tag("span", :class => [:label, "label-success"]) do
        entity.status
      end
    else
      content_tag("span", :class => :label) do
        default
      end
    end
  end
end
