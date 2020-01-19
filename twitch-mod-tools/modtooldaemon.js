const tmi = require('tmi.js');
const robot = require('robotjs');
const notifier = require('node-notifier');
const net = require('net');

const tcpHost = 'localhost';
const tcpPort = 6969;
let tcpsock;

const channelname = 'noopkat';

const keyMap = {
  desktop: 'm',
  camera: 's'
};

function handleMessage(channel, tags, message) {
  const mod = (tags.username == channelname || tags.mod);

  if (message.toLowerCase().substring(0,6) === '!scene' && mod) switchScene(message);
  if (message.includes('STOP')) sendStopNotification(tags.username);
  if (message.toLowerCase().substring(0,5) === '!line') placeVimSign(message, tags);
};

function handleTcpConnection(sock) {
 // only vim is using this so just replace the socket used every time
 tcpsock = sock;
 console.log(`vim is connected: ${sock.remoteAddress}: ${sock.remotePort}`);

 sock.on('close', function(data) {
   console.log(`vim closed connection: ${sock.remoteAddress} ${sock.remotePort}`);
 });
}

function placeVimSign(message, tags) {
  const nick = "@" + tags.username;
  const line = parseInt(message.split(' ')[1], 10);
  const suggestion = message.split(' ').slice(2).join(' ');

  const payload = [0, { line, nick, suggestion }];
  const jsonPayload = JSON.stringify(payload);

  tcpsock.write(jsonPayload + '\n');
}

function switchScene(message) {
  const scene = message.toLowerCase().split(' ')[1];
  if (!scene || !keyMap[scene]) return;
  const key = keyMap[scene];
  robot.keyTap(key, ['control', 'shift', 'command']);
}

function sendStopNotification(username) {
  notifier.notify({
    title: 'STOP!',
    message: `${username} is asking for your attention.`,
    sound: 'Glass'
  });
}

const ircClient = new tmi.Client({
  options: {debug: true},
  connection: {
    reconnect: true,
    secure: true
  },
  channels: [channelname]
});

ircClient.connect();
ircClient.on('message', handleMessage);

// tcp server for vim channel
const tcpServer = net.createServer()
tcpServer.on('connection', handleTcpConnection);
tcpServer.listen(tcpPort, tcpHost);
console.log('Server listening on ' + tcpHost +':'+ tcpPort);

