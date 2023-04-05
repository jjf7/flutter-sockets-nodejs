import * as dotenv from "dotenv";
dotenv.config();
import express from "express";
import path from "path";
import url from 'url';
import { createServer } from 'http';
import { Server } from 'socket.io'; 

import Bands from './models/Bands.js';
import Band from './models/Band.js';


const __filename = url.fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const publicPath = path.resolve( __dirname, 'public');

const server = createServer(app);
const io = new Server(server, { cors: { origin: '*' } });


const bands = new Bands();
bands.addBand(new Band( 'Bon Jovi' ));
bands.addBand(new Band( 'Korn' ));
bands.addBand(new Band( 'Metallica' ));
bands.addBand(new Band( 'Molotov' ));


io.on('connection', client => {
   
    client.on('msg', data => { console.log(data);

        io.emit('mensaje', "Nuevo mensaje de cliente")
            
    });


    client.emit('list-bands', bands.getBands());

    client.on('vote-band', ({id}) => {
        bands.voteBand(id);
        io.emit('list-bands', bands.getBands());
    });

    client.on('add-band', ( {name = 'no-name'}) => {
        bands.addBand(new Band(name));
        io.emit('list-bands', bands.getBands());
    });

    client.on('delete-band', ({id}) => {
        bands.removeBand(id);
        io.emit('list-bands', bands.getBands());
    });

    client.on('disconnect', () => { console.log('desconectado') });
  });


app.use(express.static(publicPath));

server.listen( process.env.PORT , () => {
    console.log(` Server on Port ${process.env.PORT}`);
})
