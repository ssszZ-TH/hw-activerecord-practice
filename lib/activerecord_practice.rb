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
    ## ทุกครั้งที่จะมีการใช้ puts มันจะทำการ convert to string โดยอัตโนมัติ
    ## ่ 
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.

  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)
    return Customer.where(first:"Candice")## select * from customer where
    ## คือการ show user ทุกคนที่ชื่อหน้า = Candice
    # ('first' => 'candice') 
    # :first => 'candice'
    # first: "Candice"
  end
  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    return Customer.where("email like '%@%'")
    ## ่ select * from Customer where email like "%@%"
    ## เเต่ถ้าเป็น where true มันก็คือการ injection เเต่ ruby เเม่งเทพจริงมีการป้องกันด้วย
    ## เเสดง user ทุกคน ที่ email มี @ อยู่ในนั้น
  end
  # etc. - see README.md for more details
  def self.with_dot_org_email
    Customer.where("email like '%.org'")
    ##ขี้เกียจเขียน sql ละ active record สั้นกว่าเยอะ เเล้ว มหาลัยก็ยังไม่ได้สอน sql
    ## เเสดง user ทุกตัวที่ email จบด้วย .org
  end

  def self.with_invalid_email
    Customer.where.not("email like '%@%'")
    ## เเสดง ทุกตัวที่ email ไม่มี @
  end

  def self.with_blank_email
    Customer.where("email is null")
    ## เเสดงตัวที่ email ว่างปล่าว
  end

  def self.born_before_1980
    Customer.where("birthdate < '1980-01-01'")
    ## เเสดงคนที่เกิดก่อน 1980-01-01
  end

  def self.with_valid_email_and_born_before_1980
    Customer.where("email like '%@%' and birthdate < '1980-01-01'")
    ## เเสดงคนท่เกิดหลัง 1980-01-01
  end

  def self.last_names_starting_with_b
    Customer.where("last like 'B%'").order("birthdate")
    ## เเสดง customer ที่ชื่อหลังขึ้นต้นด้วย B เเสดงเเบบเรียงตามวันเกิด
  end

  def self.twenty_youngest
    Customer.order("birthdate DESC").limit(20)
    ## เเสดง customer เรียงตามวันเกิดเเบบ descending 20 คน
    ## พูดเป็นภาษาคน เเสดงคนที่เด็กสุด 20 คน
  end

  def self.update_gussie_murray_birthdate
    Customer.find_by(first: 'Gussie').update(birthdate: '2004-02-08')
    ## หาคนที่ชื่อหน้าคือ gussie เเล้วเเก้ใขวันเกิดเป็น bla bla bla ว่าไป
  end

  def self.change_all_invalid_emails_to_blank
    Customer.where("email != '' AND email IS NOT NULL and email NOT LIKE '%@%'").update_all "email = ''"
    ## update email ผิดๆ ให้เป็นค่าว่าง
  end

  def self.delete_meggie_herman
    Customer.find_by(:first => 'Meggie', :last => 'Herman').destroy
    ## ลบคนที่ชื่อ maggie herman ออกจาก database
  end

  def self.delete_everyone_born_before_1978
    Customer.where('birthdate < ?', Time.parse("1 January 1978")).destroy_all
    ## ลบทุกคนที่เกิดก่อน 1 January 1978 โดย ที่ valid form ของ sql ต้องทำเป็น 'yyyy-mm-dd'
    ## Time.parse คือตัวช่วย convert 1 January 1978 -> '1978-01-01'
  end

  def self.to_arr
    ls = []
    Customer.all.order('id').each{|x| ls.append(x) }
    return ls
    ## สร้างเองเล่นๆ เป็นการ get customer ทุกคนมาใส่ใน array เเล้ว return ส่ง ls กลับ
  end

end

#Customer.itself.with_invalid_email.each{|x| puts x}
#print Customer.itself.to_arr ##ทดลองใช้ method เล่นๆ 
#puts Customer.itself.twenty_youngest
puts Customer.all.order('first')
#SELECT * FROM Custeomer ORDER BY 'first' ;