local stringy = require "stringy" 

contact_info = {
  abuse = stringy.split(os.getenv("SERVER_CONTACT_INFO_ABUSE"), ", ");
  admin = stringy.split(os.getenv("SERVER_CONTACT_INFO_ADMIN"), ", ");
  feedback = stringy.split(os.getenv("SERVER_CONTACT_INFO_FEEDBACK"), ", ");
  sales = stringy.split(os.getenv("SERVER_CONTACT_INFO_SALES"), ", ");
  security = stringy.split(os.getenv("SERVER_CONTACT_INFO_SECURITY"), ", ");
  support = stringy.split(os.getenv("SERVER_CONTACT_INFO_SUPPORT"), ", ");
}
