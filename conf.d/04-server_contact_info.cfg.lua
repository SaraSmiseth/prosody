local stringy = require "stringy" 

local domain = os.getenv("DOMAIN")
local abuse = os.getenv("SERVER_CONTACT_INFO_ABUSE") or "xmpp:abuse@" .. domain
local admin = os.getenv("SERVER_CONTACT_INFO_ADMIN") or "xmpp:admin@" .. domain
local feedback = os.getenv("SERVER_CONTACT_INFO_FEEDBACK") or "xmpp:feedback@" .. domain
local sales = os.getenv("SERVER_CONTACT_INFO_SALES") or "xmpp:sales@" .. domain
local security = os.getenv("SERVER_CONTACT_INFO_SECURITY") or "xmpp:security@" .. domain
local support = os.getenv("SERVER_CONTACT_INFO_SUPPORT") or "xmpp:support@" .. domain

contact_info = {
  abuse = stringy.split(abuse, ", ");
  admin = stringy.split(admin, ", ");
  feedback = stringy.split(feedback, ", ");
  sales = stringy.split(sales, ", ");
  security = stringy.split(security, ", ");
  support = stringy.split(support, ", ");
}
