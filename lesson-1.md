# Lesson 1

Lesson 1 is the theoretical section where we explain all concepts and terms.

Currently this is only available as a [slide deck](presentation.pdf)
If you are self-studying IntelMQ, please read the slide deck. If you are going through the lessons 
as part of the IntelMQ workshop, we will walk you through the slides and explain all the terms.

## terminology

- Bot: A program in IntelMQ with one purpose running on it's own. I communicates with the Pipeline to receive and send messages.
- Botnet: The superset of configured bots.
- Pipeline: The message broker with transports the messages between the bots. The user define how the bots are connected with each other, ie. defines the pipeline.
- Queue: Each bot has an input and an output queue (a pile of messages), where it reads or writes the messages to.
- Message, Event & Report: Message is the generic term for the data bunches exchanged between the bots. Reports are a kind Messages containing unparsed data, this is only exchanged between Collectors and Parsers. After the parsing, the messages are Events, which contain parsed data, and one IoC (Indicator of Compromise) only.
- to be continued...
