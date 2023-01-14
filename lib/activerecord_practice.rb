require 'sqlite3'
require 'active_record'
require 'byebug'


ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')
# Show queries in the console.
# Comment this line to turn off seeing the raw SQL queries.
ActiveRecord::Base.logger = Logger.new(STDOUT)

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.

  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)
    return Customer.where(first:"Candice")## select * from where
  end
  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    return Customer.where("email like '%@%'")
  end
  # etc. - see README.md for more details
  def self.with_dot_org_email
    Customer.where("email like '%.org'")
  end

  def self.with_invalid_email
    Customer.where.not("email like '%@%'")
  end

  def self.with_blank_email
    Customer.where("email is null")
  end

  def self.born_before_1980
    Customer.where("birthdate < '1980-01-01'")
  end

  def self.with_valid_email_and_born_before_1980
    Customer.where("email like '%@%' and birthdate < '1980-01-01'")
  end

  def self.last_names_starting_with_b
    Customer.where("last like 'B%'").order("birthdate")
  end

  def self.twenty_youngest
    Customer.order("birthdate DESC").limit(20)
  end

  def self.update_gussie_murray_birthdate
    Customer.find_by(first: 'Gussie').update(birthdate: '2004-02-08')
  end

  def self.change_all_invalid_emails_to_blank
    Customer.where("email != '' AND email IS NOT NULL and email NOT LIKE '%@%'").update_all "email = ''"
  end

  def self.delete_meggie_herman
    Customer.find_by(:first => 'Meggie', :last => 'Herman').destroy
  end

  def self.delete_everyone_born_before_1978
    Customer.where('birthdate < ?', Time.parse("1 January 1978")).destroy_all
  end
end
