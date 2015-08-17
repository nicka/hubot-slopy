# Description:
#   Receive incoming Slopy requests
#
# Dependencies:
#   aws-sdk
#
# Configuration:
#   SQS_HUBOT_QUEUE_URL
#   SQS_REGION
#   SQS_ACCESS_KEY_ID
#   SQS_SECRET_ACCESS_KEY
#
# Author:
#   Nick den Engelsman

AWS = require 'aws-sdk'

module.exports = (robot) ->
  sqs = new AWS.SQS {
    accessKeyId: process.env.SQS_ACCESS_KEY_ID
    secretAccessKey: process.env.SQS_SECRET_ACCESS_KEY
    region: process.env.SQS_REGION
  }

  receiver = (sqs, queue) ->
    robot.logger.debug "Fetching from #{queue}"
    sqs.receiveMessage {
      QueueUrl: queue
      MaxNumberOfMessages: 10
      VisibilityTimeout: 30
      WaitTimeSeconds: 20
    }, (err, data) ->
      if err?
        robot.logger.error err
      else if data.Messages
        data.Messages.forEach (message) ->
          sendMessageToRoom message
          deleteMessage queue, message
      setTimeout receiver, 50, sqs, queue

  sendMessageToRoom = (message) ->
    robot.messageRoom 'music', message.Body

  deleteMessage = (queue, message) ->
    sqs.deleteMessage {
      QueueUrl: queue
      ReceiptHandle: message.ReceiptHandle
    }, (err, data) ->
      robot.logger.error err if err?

  setTimeout receiver, 0, sqs, process.env.SQS_HUBOT_QUEUE_URL
