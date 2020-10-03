import aioxmpp
import aioxmpp.dispatcher
import asyncio
import pytest

@pytest.fixture
def client():

    jid = aioxmpp.JID.fromstr("admin@localhost")
    password = "12345678"

    client = aioxmpp.PresenceManagedClient(
        jid,
        aioxmpp.make_security_layer(
            password,
            no_verify=True
        ),
    )
    return client

@pytest.fixture
def client_with_messageDispatcher(client):
    def message_received(msg):
        print(msg)
        print(msg.body)

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
async def test_sendMessage(client_with_messageDispatcher):
    client = client_with_messageDispatcher
    recipient_jid = aioxmpp.JID.fromstr("admin@localhost")
    async with client.connected() as stream:
        msg = aioxmpp.Message(
            to=recipient_jid,
            type_=aioxmpp.MessageType.CHAT,
        )
        # None is for "default language"
        msg.body[None] = "Hello World!"

        await client.send(msg)

# def main():
#     loop = asyncio.get_event_loop()
#     loop.run_until_complete(sendMessage())
#     loop.close()

# if __name__ == '__main__':
#     main()
