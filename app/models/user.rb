class User < ApplicationRecord
  authenticates_with_sorcery!

    attr_accessor :password, :password_confirmation, :token

  CELLPHONE_RE = /\A(\+86|86)?1\d{10}\z/
  CELLPHONE_RE_2 = /\A(\+886|886)?09\d{8}\z/
  EMAIL_RE = /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/

  validates_presence_of :password, message: "密码不能为空",
    if: :need_validate_password
  validates_presence_of :password_confirmation, message: "密码确认不能为空",
    if: :need_validate_password
  validates_confirmation_of :password, message: "密码不一致",
    if: :need_validate_password
  validates_length_of :password, message: "密码最短为6位", minimum: 6,
    if: :need_validate_password
  validate :validate_email_or_cellphone, on: :create
  validates_presence_of :username, message: "用户名不能为空"

  def admin?
    is_admin
  end

  has_many :addresses, -> { where(address_type: Address::AddressType::User).order("id desc") }
  belongs_to :default_address, class_name: :Address

  has_many :orders
  has_many :payments
  has_many :post_evas

  private
  def need_validate_password
    self.new_record? ||
      (!self.password.nil? || !self.password_confirmation.nil?)
  end

  # 需要添加邮箱和手机号不能重复的校验
  def validate_email_or_cellphone
    if [self.email, self.cellphone].all? { |attr| attr.nil? }
      self.errors.add :base, "邮箱和手机号其中之一不能为空"
      return false
    else
      if self.cellphone.nil?
        if self.email.blank?
          self.errors.add :email, "邮箱不能为空"
          return false
        else
          unless self.email =~ EMAIL_RE
            self.errors.add :email, "邮箱格式不正确"
            return false
          end
        end
      else
        unless VerifyToken.available.find_by(cellphone: self.cellphone, token: self.token)
          self.errors.add :cellphone, "手机验证码不正确或者已过期"
          return false
        end
      end
    end
    return true
  end
end
