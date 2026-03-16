import pino from 'pino';

import { createApp } from './server';

const logger = pino({
  level: process.env.LOG_LEVEL ?? 'info',
});

const port = Number(process.env.PORT ?? 4000);

const app = createApp({ logger });

app.listen(port, () => {
  logger.info({ port }, 'Backend server listening');
});

