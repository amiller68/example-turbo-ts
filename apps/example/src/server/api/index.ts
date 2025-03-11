import { Router } from "express";

import * as v0 from "./v0";

const _router = Router();

_router.use("/v0", v0.router);

export const router = _router;
