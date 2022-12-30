# Authentication and Authorization

This repository is about how one can use the **devise gem**, **devise-jwt gem** and the **cancancan** gem to authenticate users and authorize users based on their different roles.

## Installation
After generating your API only rails application, add these gems to your Gemfile, `gem devise`, `gem devise-jwt`. Uncomment the `gem rack-cors`.

Run `bundle install` on the terminal.

## Configuration

Go to the config/initializers/cors.rb and add this code or uncomment this code and make changes where necessary, eg, exposing the Authorization token since we'll be using it for authenticating our API request.

```ruby
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*"

    resource "*",
      headers: :any,
      expose: ["Authorization"],
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
```

## Usage

Next, we need to generate the devise initializers, run `rails g devise:install`, this command will generate a devise initializer file for you and some configuration command for your application.

Copy the `config.action_mailer.default_url_options = { host: 'localhost', port: 3000}` line from your terminal which is found in option one.
Open the development.rb and paste the line you've copied.

Open config/initializers/devise.rb and uncomment the navigational format line which is line 266 and remove everything from  the array and save it as an empty array. 

```ruby
config.navigational_formats = []
```

## Generating User model using devise
Run `rails g devise user` to generate the user model using devise.
To generate the controllers for the user run the following command, `rails g devise:controllers users -c sessions registrations` because in our API only application we're gonna handle only signup and signin of the user which we can handle in the sessions and registrations controllers. We are also limiting the scope of the controllers to the user model only.

## Using the Devise-JWT gem
Visit this [Link](https://github.com/waiting-for-dev/devise-jwt) where you'll find the documentation on how to use the gem.

We need apply revocation strategies and we can do that using the JTIMatcher and we will do this by adding the JTI column into our user model. In the terminal run `rails g migration add_jti_to_users`.
In the migration file generated for adding JTI into the user model add the following code into the change action.

```ruby
class AddJtiToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :jti, :string, null: false 
    add_index :users, :jti, unique: true
  end
end
```
Then run `rails db:migrate` 

Check the schema.rb and you'll notice that JTI has been added to your user model and the indexes for the JTI also.

Open the user model in the user.rb file and add JWT revocation strategies, add the following code,

```ruby
class User < ApplicationRecord

include Devise::JWT::RevocationStrategies::JTIMatcher
devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self


def jwt_payload
    super
end
end
```

In the routes.rb we need to define the routes for the user model. 
Add the following code in the routes.rb file.

```ruby
devise_for :users, controllers: {
    sessions: "users/sessions",
    registration: "users/registrations"
  }
```
Open the devise.rb and here, we need to set our secret key configuration, add the following code.

```ruby
config.jwt do |jwt|
    jwt.secret = Rails.application.credentials.fetch(:secret_key_base)
    jwt.dispatch_requests = [
      ["POST", %r{^/users/sign_in$}]
    ]
    jwt.revocation_requests = [
      ["DELETE", %r{^/users/sign_out}]
    ]
    jwt.expiration_time = 120.minutes.to_i 
  end
```



