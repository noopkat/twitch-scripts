const tmi = require('tmi.js');
const robot = require('robotjs');
const notifier = require('node-notifier');

const channelname = 'noopkat';

const keyMap = {
  desktop: 'm',
  camera: 's'
};

function handleMessage(channel, tags, message) {
  const mod = (tags.username == channelname || tags.mod);

  if (message.toLowerCase().substring(0,6) === '!scene' && mod) switchScene(message);
  if (message.includes('STOP')) sendStopNotification(tags.username);
};

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

const client = new tmi.Client({
  options: {debug: true},
  connection: {
    reconnect: true,
    secure: true
  },
  channels: [channelname]
});

client.connect();
client.on('message', handleMessage);

