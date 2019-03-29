import asyncio
import json

import websockets

from sound import *
from gif import *

# launch with either fr or en, default to fr
lang = sys.argv[1] if len(sys.argv) > 1 else 'fr'
BLA_DIR = join(BLA_DIR, lang)


def format_sound_call(counter):
    return 'phrase' + counter + '.flac'


async def main_procedure():
    trackno = 1
    async with websockets.connect('ws://127.0.0.1:6437/v6.json') as websocket:
        sub = json.dumps({'focused': True})
        unsub = json.dumps({'focused': False})
        data = await websocket.recv()
        print(data)
        data = await websocket.recv()
        print(data)
        await websocket.send(sub)

        ambiant = play(join(MUS_DIR, 'coaxial.flac'), loop=True)
        ambiant.set_gain(0.05)
        play(join(BLA_DIR, f'{trackno}.flac'), until_end=True)
        trackno += 1
        change_gif('poing')
        actionPerformed = False
        while not actionPerformed:
            data = await websocket.recv()
            data = json.loads(data)
            actionPerformed = read_action_from_leap(data, 'grabStrength')
        play(join(SFX_DIR, 'confirm.flac'), until_end=True)
        ambiant.set_gain(0.1)
        change_gif('blanc')

    async with websockets.connect('ws://127.0.0.1:6437/v6.json') as websocket:
        sub = json.dumps({'focused': True})
        unsub = json.dumps({'focused': False})
        data = await websocket.recv()
        print(data)
        data = await websocket.recv()
        print(data)
        await websocket.send(sub)

        # Recherche signe et reproduction
        play(join(BLA_DIR, f'{trackno}.flac'), until_end=True)
        trackno += 1
        print('Began looking')
        time.sleep(5)
        play(join(BLA_DIR, f'{trackno}.flac'), until_end=True, left_center_right=LEFT)
        trackno += 1
        time.sleep(10)
        play(join(BLA_DIR, f'{trackno}.flac'), until_end=True)
        trackno += 1
        await websocket.send(sub)
        change_gif('rond')
        actionPerformed = False
        while not actionPerformed:
            data = await websocket.recv()
            data = json.loads(data)
            actionPerformed = read_action_from_leap(data, 'pinchStrength')
        await websocket.send(unsub)
        play(join(SFX_DIR, 'confirm.flac'), until_end=True)
        change_gif('blanc')

    async with websockets.connect('ws://127.0.0.1:6437/v6.json') as websocket:
        sub = json.dumps({'focused': True})
        unsub = json.dumps({'focused': False})
        data = await websocket.recv()
        print(data)
        data = await websocket.recv()
        print(data)
        await websocket.send(sub)

        play(join(BLA_DIR, f'{trackno}.flac'), until_end=True)
        trackno += 1
        play(join(SFX_DIR, 'powerup.flac'), until_end=True)

        # Orientation Telescope
        play(join(BLA_DIR, f'{trackno}.flac'), until_end=True)
        trackno += 1
        play(join(BLA_DIR, f'{trackno}.flac'), until_end=True)
        trackno += 1
        await websocket.send(sub)
        change_gif('feuille_g')
        actionPerformed = False
        while not actionPerformed:
            data = await websocket.recv()
            data = json.loads(data)
            actionPerformed = read_action_from_leap(data, 'moveLeft')
        await websocket.send(unsub)
        play(join(SFX_DIR, 'confirm.flac'), until_end=True)
        change_gif('blanc')

    async with websockets.connect('ws://127.0.0.1:6437/v6.json') as websocket:
        sub = json.dumps({'focused': True})
        unsub = json.dumps({'focused': False})
        data = await websocket.recv()
        print(data)
        data = await websocket.recv()
        print(data)
        await websocket.send(sub)
        play(join(SFX_DIR, 'rouages.flac'), until_end=True, left_center_right=RIGHT, back_center_front=BACK)
        play(join(SFX_DIR, 'rouages.flac'), until_end=True, left_center_right=RIGHT, back_center_front=FRONT)
        play(join(SFX_DIR, 'rouages.flac'), until_end=True, left_center_right=LEFT, back_center_front=FRONT)

        # Vent et Ouverture dôme
        play(join(BLA_DIR, f'{trackno}.flac'), until_end=True)
        trackno += 1
        play(join(SFX_DIR, 'wind.flac'), until_end=True, rotate=True)
        play(join(BLA_DIR, f'{trackno}.flac'), until_end=True)
        trackno += 1
        await websocket.send(sub)
        change_gif('feuille_d')
        actionPerformed = False
        while not actionPerformed:
            data = await websocket.recv()
            data = json.loads(data)
            actionPerformed = read_action_from_leap(data, 'handDetected')
        await websocket.send(unsub)
        play(join(SFX_DIR, 'confirm.flac'), until_end=True)
        change_gif('blanc')

    async with websockets.connect('ws://127.0.0.1:6437/v6.json') as websocket:
        sub = json.dumps({'focused': True})
        unsub = json.dumps({'focused': False})
        data = await websocket.recv()
        print(data)
        data = await websocket.recv()
        print(data)
        await websocket.send(sub)
        play(join(SFX_DIR, 'opening.flac'), until_end=True)

        # Explication passage première planète
        play(join(BLA_DIR, f'{trackno}.flac'), until_end=True)
        trackno += 1
        await websocket.send(sub)
        change_gif('feuille_g')
        actionPerformed = False
        while not actionPerformed:
            data = await websocket.recv()
            data = json.loads(data)
            actionPerformed = read_action_from_leap(data, 'moveLeft')
        await websocket.send(unsub)
        change_gif('blanc')
    async with websockets.connect('ws://127.0.0.1:6437/v6.json') as websocket:
        sub = json.dumps({'focused': True})
        unsub = json.dumps({'focused': False})
        data = await websocket.recv()
        print(data)
        data = await websocket.recv()
        print(data)
        await websocket.send(sub)

        play(join(SFX_DIR, 'confirm.flac'), until_end=True)
        ambiant.stop()

        # Planète 1
        ambiant = play(join(MUS_DIR, 'drifting_through_space.flac'), loop=True)
        ambiant.set_gain(0.2)
        play(join(BLA_DIR, f'{trackno}.flac'), until_end=True)
        trackno += 1
        time.sleep(5)
        play(join(BLA_DIR, f'{trackno}.flac'), until_end=True)
        trackno += 1
        await websocket.send(sub)
        change_gif('feuille_g')
        actionPerformed = False
        while not actionPerformed:
            data = await websocket.recv()
            data = json.loads(data)
            actionPerformed = read_action_from_leap(data, 'moveLeft')
        await websocket.send(unsub)
        change_gif('blanc')

    async with websockets.connect('ws://127.0.0.1:6437/v6.json') as websocket:
        sub = json.dumps({'focused': True})
        unsub = json.dumps({'focused': False})
        data = await websocket.recv()
        print(data)
        data = await websocket.recv()
        print(data)
        await websocket.send(sub)
        play(join(SFX_DIR, 'confirm.flac'), until_end=True)
        ambiant.stop()

        # Planète 2
        ambiant = play(join(MUS_DIR, 'drift.flac'), loop=True)
        ambiant.set_gain(0.2)
        play(join(BLA_DIR, f'{trackno}.flac'), until_end=True)
        trackno += 1
        time.sleep(5)
        play(join(BLA_DIR, f'{trackno}.flac'), until_end=True)
        trackno += 1
        await websocket.send(sub)
        change_gif('feuille_g')
        actionPerformed = False
        while not actionPerformed:
            data = await websocket.recv()
            data = json.loads(data)
            actionPerformed = read_action_from_leap(data, 'moveLeft')
        await websocket.send(unsub)
        change_gif('blanc')

    async with websockets.connect('ws://127.0.0.1:6437/v6.json') as websocket:
        sub = json.dumps({'focused': True})
        unsub = json.dumps({'focused': False})
        data = await websocket.recv()
        print(data)
        data = await websocket.recv()
        print(data)
        await websocket.send(sub)
        play(join(SFX_DIR, 'confirm.flac'), until_end=True)
        ambiant.stop()

        # Planète 3
        ambiant = play(join(MUS_DIR, 'derelict.flac'), loop=True)
        ambiant.set_gain(0.01)
        play(join(BLA_DIR, f'{trackno}.flac'), until_end=True)
        trackno += 1
        time.sleep(7)
        play(join(BLA_DIR, f'{trackno}.flac'), until_end=True)
        trackno += 1
        time.sleep(7)
        ambiant.stop()


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
        return data['hands'] and (data['hands'][0]['palmVelocity'][2] > 150)
    elif action_string == 'moveFront':
        return data['hands'] and (data['hands'][0]['palmVelocity'][2] < -150)


asyncio.get_event_loop().run_until_complete(main_procedure())
