local stringy = require "stringy" 

e2e_policy_chat = os.getenv("E2E_POLICY_CHAT") or "required"
e2e_policy_muc = os.getenv("E2E_POLICY_MUC") or "required"

local whitelist = os.getenv("E2E_POLICY_WHITELIST") or ""
e2e_policy_whitelist = stringy.split(whitelist, ", ")

e2e_policy_message_optional_chat = "For security reasons, OMEMO, OTR or PGP encryption is STRONGLY recommended for conversations on this server."
e2e_policy_message_required_chat = "For security reasons, OMEMO, OTR or PGP encryption is required for conversations on this server."
e2e_policy_message_optional_muc = "For security reasons, OMEMO, OTR or PGP encryption is STRONGLY recommended for MUC on this server."
e2e_policy_message_required_muc = "For security reasons, OMEMO, OTR or PGP encryption is required for MUC on this server."
