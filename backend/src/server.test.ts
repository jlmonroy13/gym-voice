/// <reference types="vitest" />

import pino from 'pino';
import request from 'supertest';

import { createApp } from './server';

const logger = pino({ level: 'silent' });

describe('health endpoint', () => {
  it('responds with ok', async () => {
    const app = createApp({ logger });

    const response = await request(app).get('/health');

    expect(response.status).toBe(200);
    expect(response.body).toEqual({ status: 'ok' });
  });
});

