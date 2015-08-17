# Description:
#   Control Slopy
#
# Dependencies:
#   sqs
#
# Configuration:
#   SQS_SLOPY_QUEUE
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

createMessage = (action, options, room) ->
  QUEUE.push process.env.SQS_SLOPY_QUEUE,
    method: action,
    options: options,
    room: room

module.exports = (robot) ->
  robot.respond /slopy say|say (.*)/i, (message) ->
    createMessage 'say', { params: message.match[1] }, message.room

  robot.respond /slopy start|start/i, (message) ->
    createMessage 'start', {}, message.room
    message.send("Slopy is being started")

  robot.respond /slopy pause|pause/i, (message) ->
    createMessage 'pause', {}, message.room
    message.send("Slopy paused")

  robot.respond /slopy play|play/i, (message) ->
    createMessage 'play', {}, message.room

  robot.respond /slopy play next|play next|next/i, (message) ->
    createMessage 'next', {}, message.room

  robot.respond /slopy play previous|play previous|previous/i, (message) ->
    createMessage 'previous', {}, message.room

  robot.respond /slopy repeat|repeat/i, (message) ->
    createMessage 'repeat', {}, message.room

  robot.respond /slopy shuffle|shuffle/i, (message) ->
    createMessage 'shuffle', {}, message.room

  robot.respond /volume (.*)/i, (message) ->
    createMessage 'volume', { params: message.match[1] }, message.room
    message.send("Slopy changed volume to: " + message.match[1])

  robot.respond /what\'?s playing/i, (message) ->
    createMessage 'playing?', {}, message.room
