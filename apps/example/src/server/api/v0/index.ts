import { Router } from "express";
import * as echo from "./echo";

const _router = Router();

_router.post("/echo", echo.handler);

export const router = _router;
