import { Router } from "express";

import * as livez from "./livez";
import * as readyz from "./readyz";

const _router = Router();

_router.get("/livez", livez.handler);
_router.get("/readyz", readyz.handler);

export const router = _router;
