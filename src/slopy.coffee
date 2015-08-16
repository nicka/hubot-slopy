# Description:
#   Control Slopy
#
# Dependencies:
#   sqs
#
# Configuration:
#   SQS_QUEUE
#   SQS_REGION
#   SQS_ACCESS_KEY_ID
#   SQS_SECRET_ACCESS_KEY
#
# Commands:
#   hubot start - Start playing music.
#   hubot play - Plays music.
#   hubot play next - Plays the next song.
#   hubot play previous - Plays the previous song.
#   hubot shuffle - Toggle shuffle.
#   hubot repeat - Toggle repeat.
#   hubot volume [0-100] - Sets the volume.
#   hubot say <message> - `say` your message over your speakers.
#
# Author:
#   Nick den Engelsman

SQS = require 'sqs'

QUEUE = SQS(
  access: process.env.SQS_ACCESS_KEY_ID
  secret: process.env.SQS_SECRET_ACCESS_KEY
  region: process.env.SQS_REGION
)

createMessage = (action, options) ->
  push = QUEUE.push process.env.SQS_QUEUE,
    method: action,
    options: options

module.exports = (robot) ->
  robot.respond /slopy say|say (.*)/i, (message) ->
    createMessage 'say', { params: message.match[1] }
    message.send("Slopy is saying: " + message.match[1])

  robot.respond /slopy start|start/i, (message) ->
    createMessage 'start', {}
    message.send("Slopy is being started")

  robot.respond /slopy pause|pause/i, (message) ->
    createMessage 'pause', {}
    message.send("Slopy paused")

  robot.respond /slopy play|play/i, (message) ->
    createMessage 'play', {}
    message.send("Slopy is playing")

  robot.respond /slopy play next|play next|next/i, (message) ->
    createMessage 'next', {}
    message.send("Slopy is playing the next song")

  robot.respond /slopy play previous|play previous|previous/i, (message) ->
    createMessage 'previous', {}
    message.send("Slopy is playing the previous song")

  robot.respond /slopy repeat|repeat/i, (message) ->
    createMessage 'repeat', {}
    message.send("Slopy toggled repeat")

  robot.respond /slopy shuffle|shuffle/i, (message) ->
    createMessage 'shuffle', {}
    message.send("Slopy toggled shuffle")

  robot.respond /slopy volume| slopy volume (.*)/i, (message) ->
    createMessage 'volume', { params: message.match[1] }
    message.send("Slopy changed volume to: " + message.match[1])
