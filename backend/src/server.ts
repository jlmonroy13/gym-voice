import express, { type Request, type Response } from 'express';
import type { Logger } from 'pino';

type AppDependencies = {
  logger: Logger;
};

export function createApp(deps: AppDependencies) {
  const { logger } = deps;

  const app = express();

  app.use(express.json());

  app.get('/health', (req: Request, res: Response) => {
    logger.debug({ path: req.path }, 'Health check');
    res.status(200).json({ status: 'ok' });
  });

  return app;
}

