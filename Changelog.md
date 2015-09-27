[1.0.0 / 2015-03-02]
==================

* First public release of GoalSmashers internal tools;
* GS::Controllers::Application - Sinatra app utils, like `json` and `env;
* GS::Controllers::EmailPreview - Show email previews in the browser, see source for details;
* Class - `cattr_accessor`, `cattr_reader`, `cattr_writer`;
* Date - `to_json` helpers;
* Fixnum - Time helpers, like `1.day.ago` or `30.minutes`;
* Time - Adding / subtracting time units, like `Time.now + 10.minutes`;
* Various time-related helpers, like `noon`, `midnight`, `beginning_of_month`, etc;
* GS::Helpers::ApplicationHelper - various view helpers for layout, I18n, and assets;
* GS::Helpers::SharedHelper - URL building;
* GS::Jobs::AbstractJobs - as name implies;
* GS::Live::Message - a message broadcasted via WebSockets;
* GS::Live::Notifier - an abstract notifier class for WebSocket messaging;
* GS::Live::RedisNotifier - a notifier implemented on top of Redis pubsub;
* GS::Mail::GenericMailer - a generic mailer class;
* GS::Mail::MailProxy - an email builder and delivery mechanism using Tilt for templating and Postmark for delivery;
* GS::Middleware::NotificationFilter - a Rack middleware inlining WebSocket messaging for a backup delivery;
* GS::Middleware::UAFilter - a Rack middleware adding `X-UA-Compatible` headers;
* GS::Models::AuthenticationModel - a model Mixin for Warden authentication;
* GS::Rake::AssetsTask - Rake tasks for asset management, tied to `assets_packager`;
* GS::Rake::BackgroundTask - background jobs management for Navvy;
* GS::Rake::SequelTask - DB related tasks using Sequel ORM;
* GS::Rake::SpecTask - various spec running tasks;
* GS::Rake::UtilsTask - `rake db` and `rake c` for opening db and console sessions respectively;
* GS::Utils::BackgroundJob - as name implies;
* GS::JSON - Yajl JSON serializing shortcuts;
* ScopedBackend - an extension to I18n supporting scoped translations (with metadata);
* Sequel::Model - common Sequel plugins;
* GS::Utils::TScoped - I18n translation scoping helpers;
