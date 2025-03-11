import { Router } from "express";
import * as hello from "./hello";

const _router = Router();

_router.post("/render", hello.handler);

export const router = _router;
