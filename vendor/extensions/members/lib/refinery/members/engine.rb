module Refinery
  module Members
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::Members

      engine_name :refinery_members

      initializer "register refinerycms_members plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.name = "members"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.members_admin_members_path }
          plugin.pathname = root
          plugin.activity = {
            :class_name => :'refinery/members/member',
            :title => 'name'
          }
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Members)
      end
    end
  end
end
