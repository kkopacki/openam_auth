module OpenamAuth
  module Config

    extend self

    def parameter(*names)
      names.each do |name|
        attr_accessor name

        define_method name do |*values|
          value = values.first
          value ? self.send("#{name}=", value) : instance_variable_get("@#{name}")
        end
      end
    end

    def config(&block)
      instance_eval &block
    end

    def config_attrs
      [
        :openam_url,
        :return_url
      ]
    end
  end

  Config.config do
    config_attrs.each do |config_attr|
      parameter config_attr
    end
  end
end

