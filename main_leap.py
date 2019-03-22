import websockets
import json
import openal
import os, sys


async def main_procedure():
    async with websockets.connect('ws://127.0.0.1:6437/v6.json') as websocket:
        sub = json.dumps({'focused': True})
        unSub = json.dumps({'focused': False})
        data = await websocket.recv()
        print(data)
        data = await websocket.recv()
        print(data)
        await websocket.send(sub)

        print('coucou')
        actionPerformed = False
        while not actionPerformed:
            data = await websocket.recv()
            data = json.loads(data)
            actionPerformed = read_action_from_leap(data, 'pinchStrength')
        await websocket.send(unSub)
        print('coucou2')
        await websocket.send(sub)

def format_json(data):
    file = open('JSONParsed', 'w')
    sys.stdout = file
    print(json.dumps(data, sort_keys=True, indent=4, separators=(',', ': ')))


def read_action_from_leap(data, action_string):
        if action_string == 'grabStrength':
            return data['hands'] and (data['hands'][0][action_string] == 1.0)
        elif action_string == 'pinchStrength':
            return data['hands'] and (data['hands'][0]['grabStrength']) < 0.5 and (data['hands'][0][action_string] == 1.0)
        elif action_string == 'moveRight':
            return data['hands'] and (data['hands'][0]['palmVelocity'][0] > 150)
        elif action_string == 'moveLeft':
            return data['hands'] and (data['hands'][0]['palmVelocity'][0] < -150)
        elif action_string == 'moveUp':
            return data['hands'] and (data['hands'][0]['palmVelocity'][1] > 150)
        elif action_string == 'moveDown':
            return data['hands'] and (data['hands'][0]['palmVelocity'][1] < -150)
        elif action_string == 'moveBack':
            return  data['hands'] and (data['hands'][0]['palmVelocity'][2] > 150)
        elif action_string == 'moveFront':
            return data['hands'] and (data['hands'][0]['palmVelocity'][2] < -150)
