# hacksaw-profiler
A simple intstrumentation-based profiler.

## Usage
### Profile block start/end
```hx
Profiler.profileBlockStart("block1");
// Work you want to profile
Profiler.profileBlockEnd();
```
### Profile block
```hx
Profiler.profileBlock("block3", {
    // Work you want to profile
});
```
### Profile function
```hx
@:build(hacksaw.profiler.Profiler.injectProfiler())
class Foo {
	@:profile
	public function bar() {
		// Work you want to profile
	}
}
```
### Dumping profile to json file
```hx
Profiler.profileBlockStart("block2");
// Work you want profile
Profiler.profileBlockEnd();

Profiler.dumpToJsonFile("profile_dump.json");
```
### Print generated json
```hx
Profiler.profileBlockStart("block2");
// Work you want profile
Profiler.profileBlockEnd();

trace(Profiler.dumpToJson());
```
You can then open up [chrome://tracing](chrome://tracing) or https://www.speedscope.app/ to view the profile and inspect it.

## Required libs
`thx.core`\
`buddy`(required for unit tests)