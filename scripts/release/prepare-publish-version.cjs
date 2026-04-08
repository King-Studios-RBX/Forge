const fs = require("node:fs");
const path = require("node:path");
const childProcess = require("node:child_process");

const REGISTRY_URL = "https://npm.pkg.github.com";
const PACKAGE_NAME = "@king-studios-rbx/forge";

function parseCoreVersion(version) {
	const match = /^([0-9]+)\.([0-9]+)\.([0-9]+)/.exec(version.trim());
	if (!match) {
		throw new Error(`Invalid semver string: ${version}`);
	}

	return {
		major: Number(match[1]),
		minor: Number(match[2]),
		patch: Number(match[3]),
	};
}

function compareVersions(a, b) {
	if (a.major !== b.major) return a.major - b.major;
	if (a.minor !== b.minor) return a.minor - b.minor;
	return a.patch - b.patch;
}

function formatVersion(version) {
	return `${version.major}.${version.minor}.${version.patch}`;
}

function getPublishedVersion() {
	try {
		const output = childProcess
			.execSync(`npm view ${PACKAGE_NAME} version --registry ${REGISTRY_URL}`, {
				encoding: "utf8",
				stdio: ["ignore", "pipe", "pipe"],
			})
			.trim();

		return output.length > 0 ? output : undefined;
	} catch {
		return undefined;
	}
}

function run() {
	const packageJsonPath = path.join(process.cwd(), "package.json");
	const packageJson = JSON.parse(fs.readFileSync(packageJsonPath, "utf8"));

	const localCore = parseCoreVersion(packageJson.version);
	const publishedVersion = getPublishedVersion();

	let baseVersion = localCore;
	if (publishedVersion) {
		const publishedCore = parseCoreVersion(publishedVersion);
		if (compareVersions(publishedCore, baseVersion) > 0) {
			baseVersion = publishedCore;
		}
	}

	const nextVersion = {
		major: baseVersion.major,
		minor: baseVersion.minor,
		patch: baseVersion.patch + 1,
	};

	packageJson.version = formatVersion(nextVersion);
	fs.writeFileSync(packageJsonPath, `${JSON.stringify(packageJson, null, "\t")}\n`);

	console.log(
		`[publish-version] ${packageJson.name}: ${formatVersion(localCore)} -> ${packageJson.version}${
			publishedVersion ? ` (published latest: ${publishedVersion})` : ""
		}`,
	);
}

run();
