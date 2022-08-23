plugin_paths = { "/usr/local/lib/prosody/custom-modules/" };

modules_enabled = {
    -- Generally required
    "roster"; -- Allow users to have a roster. Recommended ;)
    "saslauth"; -- Authentication for clients and servers. Recommended if you want to log in.
    "tls"; -- Add support for secure TLS on c2s/s2s connections
    "dialback"; -- s2s dialback support
    "disco"; -- Service discovery

    -- Not essential, but recommended
    "blocklist"; -- Simple modern protocol for blocking remote JIDs (XEP-0191)
    "private"; -- Private XML storage (for room bookmarks, etc.)
    "vcard4"; -- Allow users to set vCards
    "vcard_legacy"; -- Support older clients
    "mam"; -- Message Archive (XEP-0313)
    "carbons"; -- Share and sync conversations (XEP-0280)
    "csi_simple"; -- Buffer unimportant traffic for simple optimisation for clients using state indication

    -- Nice to have
    "version"; -- Replies to server version requests
    "uptime"; -- Report how long server has been running
    "time"; -- Let others know the time here on this server
    "ping"; -- Replies to XMPP pings with pongs
    "pep"; -- Enables users to publish their mood, activity, playing music and more
    "register"; -- Allow users to register on this server using a client and change passwords
    --"muc"; -- [Loaded as component, therefore commented here] Multi-user chats (XEP-0045)

    -- Admin interfaces
    "admin_adhoc"; -- Allows administration via an XMPP client that supports ad-hoc commands
    --"admin_telnet"; -- Opens telnet console interface on localhost port 5582

    -- HTTP modules
    --"bosh"; -- Enable BOSH clients, aka "Jabber over HTTP"
    --"http_files"; -- Serve static files from a directory over HTTP

    -- Other specific functionality
    "posix"; -- POSIX functionality, sends server to background, enables syslog, etc.
    --"groups"; -- Shared roster support
    "announce"; -- Send announcement to all online users
    --"welcome"; -- Welcome users who register accounts
    --"watchregistrations"; -- Alert admins of registrations
    --"motd"; -- Send a message to users when they log in
    --"legacyauth"; -- Legacy authentication. Only used by some old clients and bots.
    "lastactivity";
    "server_contact_info"; -- This module lets you advertise various contact addresses for your XMPP service via XEP-0157.
};

-- These modules are auto-loaded, but should you want
-- to disable them then uncomment them here:
modules_disabled = {
    -- "offline"; -- Store offline messages
    -- "c2s"; -- Handle client connections
    "s2s"; -- Handle server-to-server connections
};
