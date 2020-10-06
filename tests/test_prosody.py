import aiosasl
import aioxmpp
import aioxmpp.dispatcher
import asyncio
import pytest

@pytest.fixture
def client(client_username, password):

    jid = aioxmpp.JID.fromstr(client_username)

    client = aioxmpp.PresenceManagedClient(
        jid,
        aioxmpp.make_security_layer(
            password,
            no_verify=True
        ),
    )
    return client

@pytest.fixture
def client_with_message_dispatcher(client):
    def message_received(msg):
        print(msg)
        print(msg.body)
        assert msg.body == "Hello World!"

    # obtain an instance of the service
    message_dispatcher = client.summon(
    aioxmpp.dispatcher.SimpleMessageDispatcher
    )

    # register a message callback here
    message_dispatcher.register_callback(
        aioxmpp.MessageType.CHAT,
        None,
        message_received,
    )
    return client

@pytest.mark.asyncio
@pytest.mark.parametrize("client_username, password", [("admin@localhost", "12345678")])
async def test_send_message_from_admin_to_user1(client):
    recipient_jid = aioxmpp.JID.fromstr("user1@localhost")
    async with client.connected() as stream:
        msg = aioxmpp.Message(
            to=recipient_jid,
            type_=aioxmpp.MessageType.CHAT,
        )
        # None is for "default language"
        msg.body[None] = "Hello World!"

        await client.send(msg)

@pytest.mark.asyncio
@pytest.mark.parametrize("client_username, password", [("admin@localhost", "12345678")])
async def test_send_message_from_admin_to_user2(client):
    recipient_jid = aioxmpp.JID.fromstr("user2@localhost")
    async with client.connected() as stream:
        msg = aioxmpp.Message(
            to=recipient_jid,
            type_=aioxmpp.MessageType.CHAT,
        )
        msg.body[None] = "Hello World!"

        await client.send(msg)

@pytest.mark.asyncio
@pytest.mark.parametrize("client_username, password", [("user1@localhost", "12345678")])
async def test_send_message_from_user1_to_user2(client):
    recipient_jid = aioxmpp.JID.fromstr("user2@localhost")
    async with client.connected() as stream:
        msg = aioxmpp.Message(
            to=recipient_jid,
            type_=aioxmpp.MessageType.CHAT,
        )
        msg.body[None] = "Hello World!"

        await client.send(msg)

@pytest.mark.asyncio
@pytest.mark.parametrize("client_username, password", [("user2@localhost", "12345678")])
async def test_send_message_from_user2_to_user3(client):
    recipient_jid = aioxmpp.JID.fromstr("user3@localhost")
    async with client.connected() as stream:
        msg = aioxmpp.Message(
            to=recipient_jid,
            type_=aioxmpp.MessageType.CHAT,
        )
        msg.body[None] = "Hello World!"

        await client.send(msg)

@pytest.mark.asyncio
@pytest.mark.parametrize("client_username, password", [("user2@localhost", "12345678")])
async def test_send_message_from_user2_to_nonexisting(client):
    recipient_jid = aioxmpp.JID.fromstr("nonexisting@localhost")
    async with client.connected() as stream:
        msg = aioxmpp.Message(
            to=recipient_jid,
            type_=aioxmpp.MessageType.CHAT,
        )
        msg.body[None] = "Hello World!"

        await client.send(msg)

@pytest.mark.asyncio
@pytest.mark.parametrize("client_username, password", [("user2@localhost", "wrong password")])
async def test_can_not_log_in_with_wrong_password(client):
    with pytest.raises(aiosasl.AuthenticationFailure):
        recipient_jid = aioxmpp.JID.fromstr("nonexisting@localhost")
        async with client.connected() as stream:
            msg = aioxmpp.Message(
                to=recipient_jid,
                type_=aioxmpp.MessageType.CHAT,
            )
            msg.body[None] = "Hello World!"

            await client.send(msg)
