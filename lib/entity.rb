module Entity
  def self.included(base)
    base.instance_eval do
      belongs_to :user
      base.extend(ClassMethods)
    end
  end

  module ClassMethods
    def with_tags
      where("array_length(akeys(tags), 1) > 0")
    end

    def ordered
      order('id asc')
    end

    def status_changed
      where("status is not null and status != ?", default_status)
    end

    def percentage_status_changed
      if self.count > 0 && self.with_tags.count > 0
        ((self.with_tags.status_changed.count.to_f / self.with_tags.count) * 100).to_i
      else
        0
      end
    end
  end

  # Show the tags in a fashion recognisable to OSM contributors, rather than a ruby Hash.to_s format
  def tags_string
    tags.map {|k,v| "#{k}=#{v}"}.join(", ")
  end

  def ordered_tags
    tags.sort_by{ |k,v| k }
  end

  def feature_geojson
    RGeo::GeoJSON.encode(geom).to_json
  end
end