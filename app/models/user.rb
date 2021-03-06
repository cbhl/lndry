class User < ActiveRecord::Base

  has_many :uses
  has_many :messages

  validates :email,
    :presence => true,
    :format => { :with => EmailSupport::RFC822::EmailAddress }

  def first_name
    pieces = name.split(' ')
    if pieces.length == 1
      pieces[0]
    else
      pieces[0...-1].join(' ')
    end
  rescue
    nil
  end

  def last_name
    pieces = name.split(' ')
    pieces[-1]
  rescue
    nil
  end

  Type.all.each do |type|
    define_method "#{type.slug}_uses" do
      uses.joins(:resource).where('type_id = ?', type.id)
    end
  end

  def email_variables
    {
      :first_name => (first_name or "resident"),
      :last_name => last_name,
      :name => (name or "resident")
    }
  end

end
