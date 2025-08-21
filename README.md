# loupe-profiler
A simple instrumentation-based profiler.

## Usage
### Enable profiling
```haxe
Profiler.startProfiling(); // Profiling is disabled by default, so you must always do this once before starting to call the profiling functions or they won't be recorded.
```
### Disable profiling
```haxe
Profiler.stopProfiling();
```
### Profile block start/end
```haxe
Profiler.profileBlockStart("block1");
// Work you want to profile
Profiler.profileBlockEnd();
```
### Profile block
```haxe
Profiler.profileBlock("block3", {
    // Work you want to profile
});
```
### Profile function
```haxe
@:build(hacksaw.profiler.Profiler.injectProfiler())
class Foo {
    @:profile
    public function bar() {
        // Work you want to profile
    }
}
```
### Dumping profile to json file
```haxe
Profiler.profileBlockStart("block2");
// Work you want profile
Profiler.profileBlockEnd();

Profiler.dumpToJsonFile("profile_dump.json");
```
### Print generated json
```haxe
Profiler.profileBlockStart("block2");
// Work you want profile
Profiler.profileBlockEnd();

trace(Profiler.dumpToJson());
```
You can then open up [chrome://tracing](chrome://tracing) or https://www.speedscope.app/ to view the profile and inspect it.

## Testing
You can run the unit tests with `haxe test.hxml`

## Required libs
`thx.core`\
`buddy`(required for unit tests)
