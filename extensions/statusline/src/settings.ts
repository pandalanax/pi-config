import { readFileSync } from "node:fs";
import { join } from "node:path";
import process from "node:process";
import { getAgentDir } from "@earendil-works/pi-coding-agent";
import type { SegmentName, StatuslineConfig, StatuslinePresetName } from "../presets/types.js";

const SETTINGS_FILE = "pi-statusline-settings.json";
const DEFAULT_PRESET: StatuslinePresetName = "tokyo-night";
const DEFAULT_SEGMENTS: SegmentName[] = [
	"brand",
	"model",
	"thinking",
	"cwd",
	"branch",
	"tools",
	"context",
	"codexUsage",
	"fileChanges",
];

export interface StatuslineSettings {
	extensionStatusIcons: Record<string, string>;
}

export function createDefaultConfig(): StatuslineConfig {
	return {
		preset: readStatuslinePreset(),
		palette: "candy",
		density: "compact",
		separator: "dot",
		showLabels: false,
		segments: [...DEFAULT_SEGMENTS],
		extensionStatusIcons: readStatuslineSettings().extensionStatusIcons,
	};
}

export function readStatuslineSettings(
	settingsPath = join(getAgentDir(), SETTINGS_FILE),
): StatuslineSettings {
	try {
		return normalizeStatuslineSettings(JSON.parse(readFileSync(settingsPath, "utf8")));
	} catch {
		return { extensionStatusIcons: {} };
	}
}

export function normalizeStatuslineSettings(value: unknown): StatuslineSettings {
	if (!value || typeof value !== "object" || Array.isArray(value)) return { extensionStatusIcons: {} };
	const icons = (value as { extensionStatusIcons?: unknown }).extensionStatusIcons;
	if (!icons || typeof icons !== "object" || Array.isArray(icons)) {
		return { extensionStatusIcons: {} };
	}
	return {
		extensionStatusIcons: Object.fromEntries(
			Object.entries(icons).filter(
				(entry): entry is [string, string] => typeof entry[1] === "string",
			),
		),
	};
}

function readStatuslinePreset(): StatuslinePresetName {
	const value = process.env.PI_STATUSLINE_PRESET?.trim().toLowerCase();
	return value === "classic" || value === "tokyo-night" ? value : DEFAULT_PRESET;
}
