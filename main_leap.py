import websockets
import json
import openal
import os, sys
import src.main_sound as sound


async def main_procedure():
    async with websockets.connect('ws://127.0.0.1:6437/v6.json') as websocket:
        sub = json.dumps({'focused': True})
        unSub = json.dumps({'focused': False})
        data = await websocket.recv()
        print(data)
        data = await websocket.recv()
        print(data)
        await websocket.send(sub)

        sound.play('source/gas.flac', loop=True)
        print('Track 1')
        # TODO Insert track 1 -> "Hé, toi là..."
        actionPerformed = False
        while not actionPerformed:
            data = await websocket.recv()
            data = json.loads(data)
            actionPerformed = read_action_from_leap(data, 'grabStrength')
        await websocket.send(unSub)
        print('Track 2')
        sound.play('source/gas.flac', until_end=True)
        print('test')
        #TODO Insert track 2 -> "Super ! Merci beaucoup"
        await websocket.send(sub)
        actionPerformed = False
        while not actionPerformed:
            data = await websocket.recv()
            data = json.loads(data)
            actionPerformed = read_action_from_leap(data, 'pinchStrength')
        await websocket.send(unSub)
        print('Track 3')
        print('Track 4 (Son zwoosh)')
        print('Track 5')
        print('Track 6 -> Viens voir ici')
        print('Track 7 -> COmmence par glisser ta main')
        await websocket.send(sub)
        actionPerformed = False
        while not actionPerformed:
            data = await websocket.recv()
            data = json.loads(data)
            actionPerformed = read_action_from_leap(data, 'moveLeft')
        await websocket.send(unSub)
        print('Sons orientation telescope')
        print('Track Super')
        print('Bruit de vent')
        print('Track Brrrr il fait froid')
        await websocket.send(sub)
        actionPerformed = False
        while not actionPerformed:
            data = await websocket.recv()
            data = json.loads(data)
            actionPerformed = read_action_from_leap(data, 'handDetected')
        await websocket.send(unSub)
        print('Son téléscope qui s\'ouvre')
        print('Track balaie la main devant toi')
        await websocket.send(sub)
        actionPerformed = False
        while not actionPerformed:
            data = await websocket.recv()
            data = json.loads(data)
            actionPerformed = read_action_from_leap(data, 'moveLeft')
        await websocket.send(unSub)
        print('Track Trappist1E')
        print('Track balaie la main devant toi')
        await websocket.send(sub)
        actionPerformed = False
        while not actionPerformed:
            data = await websocket.recv()
            data = json.loads(data)
            actionPerformed = read_action_from_leap(data, 'moveLeft')
        await websocket.send(unSub)
        print('Track Kepler-186f')
        print('Track balaie la main devant toi dernière planèye')
        await websocket.send(sub)
        actionPerformed = False
        while not actionPerformed:
            data = await websocket.recv()
            data = json.loads(data)
            actionPerformed = read_action_from_leap(data, 'moveLeft')
        await websocket.send(unSub)
        print('Track Kepler 16b')
        print('Track fin du jeu')


def format_json(data):
    file = open('JSONParsed', 'w')
    sys.stdout = file
    print(json.dumps(data, sort_keys=True, indent=4, separators=(',', ': ')))


def read_action_from_leap(data, action_string):
        if action_string == 'grabStrength':
            return data['hands'] and (data['hands'][0][action_string] == 1.0)
        elif action_string == 'handDetected':
            return data['hands']
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
