import { Router } from "express";

import * as livez from "./livez";
import * as readyz from "./readyz";
import * as versionz from "./versionz";

const _router = Router();

_router.get("/livez", livez.handler);
_router.get("/readyz", readyz.handler);
_router.get("/versionz", versionz.handler);

export const router = _router;
