# Go Temporal Dsl Prompt File Coding Standards

This skill provides language, framework, and tooling rules.

---
description:
globs:
alwaysApply: false
---
## Example Usage

The following Go snippets illustrate how to set up the Temporal worker to listen for tasks defined by this DSL and how to start an instance of a DSL-based workflow.

**Worker Setup (`dsl/worker/main.go`):**

This shows the basic setup for a Temporal worker that registers the DSL workflow interpreter (`dsl.SimpleDSLWorkflow`) and the activities it might invoke (like `dsl.SampleActivity1`).

```go
package main

import (
	"log"

	"go.temporal.io/sdk/client"
	"go.temporal.io/sdk/worker"

	"path/to/your/dsl" // Assuming your DSL package path
)

func main() {
	c, err := client.Dial(client.Options{})
	if err != nil {
		log.Fatalln("Unable to create client", err)
	}
	defer c.Close()

	w := worker.New(c, "dsl-task-queue", worker.Options{})

	// Register the DSL workflow interpreter
	w.RegisterWorkflow(dsl.SimpleDSLWorkflow)

	// Register activities used by the DSL workflows
	activities := &dsl.SampleActivities{}
	w.RegisterActivity(activities)
	// Register other activities...

	err = w.Run(worker.InterruptCh())
	if err != nil {
		log.Fatalln("Unable to start worker", err)
	}
}
```

**Workflow Starter (`dsl/starter/main.go`):**
This demonstrates how to start a workflow instance. It typically involves reading a DSL definition (e.g., from a YAML file), parsing it into the `dsl.Workflow` struct, and then using the Temporal client to execute `SimpleDSLWorkflow` with that struct.

```go
package main

import (
	"context"
	"log"
	"os"
	"github.com/pborman/uuid"

	"go.temporal.io/sdk/client"
	"gopkg.in/yaml.v3"

	"path/to/your/dsl" // Assuming your DSL package path
)

func main() {
	// Example: Reading DSL definition from a file (e.g., workflow1.yaml)
	dslFilePath := "dsl/workflow1.yaml" // Or get from flag
	data, err := os.ReadFile(dslFilePath)
	if err != nil {
		log.Fatalln("Unable to read DSL file", err)
	}
	var dslWorkflow dsl.Workflow
	err = yaml.Unmarshal(data, &dslWorkflow)
	if err != nil {
		log.Fatalln("Unable to parse DSL definition", err)
	}

	c, err := client.Dial(client.Options{})
	if err != nil {
		log.Fatalln("Unable to create client", err)
	}
	defer c.Close()

	options := client.StartWorkflowOptions{
		ID:        "dsl-workflow-" + uuid.New(), // Example ID
		TaskQueue: "dsl-task-queue",
	}

	we, err := c.ExecuteWorkflow(context.Background(), options, dsl.SimpleDSLWorkflow, dslWorkflow)
	if err != nil {
		log.Fatalln("Unable to execute workflow", err)
	}
	log.Println("Started workflow", "WorkflowID", we.GetID(), "RunID", we.GetRunID())

	// Optionally wait for completion
	var result []byte
	err = we.Get(context.Background(), &result)
	if err != nil {
		log.Fatalln("Workflow execution failed", err)
	}
	log.Println("Workflow completed successfully.")
}

```


---
description:
globs:
alwaysApply: false
---
# Agentic Coding with Go Temporal DSL: Humans Design, Agents Implement!

> If you are an AI agent involved in building or modifying Temporal workflows using this project's Go DSL, read this guide **VERY carefully**! This is the most important chapter in the entire ruleset. Always (1) start with the simplest possible workflow structure, (2) confirm the high-level design (Sequence vs. Parallel, Activity needs) with the human before implementation, and (3) frequently ask for feedback on the generated DSL structure and data flow (`bindings`).
{: .warning }

## Agentic Workflow Building Steps

Building workflows with the Go Temporal DSL should be a collaboration:

| Step                     | Human      | AI        | Comment                                                                        |
|:-------------------------|:----------:|:---------:|:-------------------------------------------------------------------------------|
| 1. Requirements        | ★★★ High  | ★☆☆ Low   | Humans define the overall business process and goals.                          |
| 2. High-Level Flow       | ★★☆ Medium | ★★☆ Medium | Humans outline the main steps (sequential/parallel), AI suggests DSL structure. |
| 3. Activities            | ★★☆ Medium | ★★☆ Medium | Humans specify required Activities (or ask AI to propose), AI checks `activities.mdc`. |
| 4. Data Flow (`bindings`) | ★☆☆ Low   | ★★★ High  | AI determines necessary `Variables`, `Arguments`, `Result` based on the flow.   |
| 5. DSL Implementation    | ★☆☆ Low   | ★★★ High  | AI generates the `Workflow` struct using `Sequence`, `Parallel`, `ActivityInvocation`. |
| 6. Review & Refine       | ★★☆ Medium | ★★☆ Medium | Humans review the DSL, AI helps refine based on feedback.                     |
| 7. Activity Implementation| ★☆☆ Low   | ★★★ High  | AI implements required Activity functions/methods (following `activities.mdc`). |

1.  **Requirements**: Humans clarify the business process to be automated. Understand what tasks need to be done, in what order, and what data is involved.
    *   Is it a simple sequence of tasks?
    *   Are there steps that can run in parallel?
    *   What data needs to pass between steps?

2.  **High-Level Flow Design**: Outline the workflow structure. Humans should specify the core logic.
    *   Should the `Root` `Statement` be a `Sequence` or a `Parallel` block? Or a single `Activity`?
    *   Break down complex logic into nested `Sequence` and `Parallel` blocks.
    *   Visualize the flow mentally or sketch it out.
    *   **AI**: Based on the human's description, propose the basic `Sequence` / `Parallel` structure within the `Workflow` struct.

3.  **Activities**: Identify the necessary Temporal Activities needed for the workflow.
    *   Humans list the activities required for each step.
    *   **AI**: Consult `activities.mdc` for existing activities and their expected signatures/behavior. If new activities are needed, propose names and functionality based on the task requirements, following the guidelines in `activities.mdc`.

4.  **Data Flow (`bindings`) Design**: Plan how data will flow through the workflow using the `bindings` map.
    *   **AI**: Determine the initial `Workflow.Variables` needed.
    *   **AI**: For each `ActivityInvocation`:
        *   Identify the required input variable names (`Arguments`) by looking at which data is needed from previous steps (present in `bindings`).
        *   Define the output variable name (`Result`) where the activity's result should be stored in `bindings` for subsequent steps.
    *   **Human**: Review the proposed `bindings` flow for correctness.

5.  **DSL Implementation**: Generate the Go code for the `dsl.Workflow` struct.
    *   🎉 Agentic Coding time! Humans have defined the structure and data needs.
    *   **AI**: Construct the nested `Statement`, `Sequence`, `Parallel`, and `ActivityInvocation` structs precisely as designed.
    *   Ensure correct `Name`, `Arguments`, and `Result` strings are used for each `ActivityInvocation`.
    *   Refer to `workflow.mdc` for the exact struct definitions and `example-usage.mdc` for syntax examples.
    *   Keep the DSL definition clean and readable.

6.  **Review & Refine**: Humans review the generated Go DSL code.
    *   Does the structure match the intended workflow logic?
    *   Is the data flow (`bindings` usage) correct?
    *   **AI**: Modify the DSL struct based on human feedback.

7.  **Activity Implementation**: If new activities were identified, implement them.
    *   **AI**: Create the necessary Go functions/methods for the activities, strictly following the guidelines in `activities.mdc` (context handling, logging, return values, naming conventions).
    *   Ensure the activity function signatures match the expected inputs derived during the Data Flow design.

## Key Files & Concepts Recap

*   **`index.mdc`**: High-level overview of the DSL.
*   **`workflow.mdc`**: Defines the core DSL Go structs (`Workflow`, `Statement`, etc.) and the execution logic (`SimpleDSLWorkflow`). Contains the *source code* for the DSL itself.
*   **`activities.mdc`**: Rules and examples for implementing the actual Go functions/methods that perform the work (Temporal Activities).
*   **`example-usage.mdc`**: Concrete examples of how to define workflows using the Go DSL structs.
*   **`guide.mdc` (This file)**: Step-by-step guide for AI collaboration in building workflows.
*   **Core Idea**: Define workflow *logic* declaratively using Go structs (`workflow.mdc`), which then invoke separate Go functions/methods (*activities.mdc*) to perform actions.
*   **Data Flow**: The `bindings map[string]string` is crucial for passing data. Plan it carefully.

By following these steps and referencing the relevant rule files, you can effectively assist humans in creating and modifying Temporal workflows using this project's custom Go DSL.


---
description:
globs:
alwaysApply: false
---
# Go Temporal DSL for Workflow Definition

A lightweight, declarative DSL in Go for defining Temporal workflows. This approach uses Go structs to represent workflow logic, separating the definition from the activity implementation.

- **Declarative**: Define workflows using Go structs for `Sequence`, `Parallel`, and `ActivityInvocation`.
- **Separation of Concerns**: Keep workflow logic (`Workflow` struct) separate from activity execution code (Activity methods).
- **Data Flow**: Manage state and pass data between steps using a shared `bindings` map.

## Core DSL Structures

We model the workflow using Go structs defined in the `dsl` package:

- `Workflow`: Top-level struct holding initial `Variables` and the `Root` `Statement`.
- `Statement`: Represents a single step, containing either an `ActivityInvocation`, `Sequence`, or `Parallel`.
- `ActivityInvocation`: Defines how to call a specific Temporal Activity (`Name`, `Arguments`, `Result`).
- `Sequence`: A slice of `Statement`s executed sequentially.
- `Parallel`: A slice of `Statement`s executed concurrently.

## Execution Flow

Workflows defined with this DSL are executed by the `SimpleDSLWorkflow` function:

- Takes `workflow.Context` and the `dsl.Workflow` struct as input.
- Initializes a `bindings` map from `Workflow.Variables`.
- Recursively executes the `Statement`s starting from `Root`.
- Uses `workflow.ExecuteActivity` to invoke activities based on `ActivityInvocation`.
- Handles sequential execution for `Sequence` and concurrent execution (with cancellation) for `Parallel`.

## Data Handling (`bindings`)

- The `bindings map[string]string` acts as the shared state.
- Initial values come from `Workflow.Variables`.
- `ActivityInvocation.Arguments` specifies which keys from `bindings` provide input.
- `ActivityInvocation.Result` specifies the key in `bindings` to store the activity's output.

## Activity Implementation

- Activities are standard Go functions/methods registered with Temporal (see `activities.mdc`).
- They accept `context.Context` and input arguments, returning a result and an error.
- Use `activity.GetLogger(ctx)` for logging within activities.
- The DSL invokes activities by their registered string `Name`.

## Ready to build Workflows?

Check out `guide.mdc` and `workflow.mdc` for detailed rules and the `example-usage.mdc` for specific examples of defining workflows using this Go DSL.


---
description: Go Temporal DSL Workflow & Activity Rules (Self-Contained)
alwaysApply: false
globs:
  - "**/*.go"
rules:
  - index.mdc
  - guide.mdc
  - workflow.mdc
  - activities.mdc
  - example-usage.mdc
---


---
description:
globs:
alwaysApply: false
---
This file provides rules and context for generating or understanding Go code related to a custom Domain Specific Language (DSL) for defining Temporal workflows within this project.

**DSL Overview:**

This project uses a specific Go-based DSL to define Temporal workflows declaratively. The core idea is to represent workflow logic using nested structures rather than imperative Go code directly within the workflow function.

**Core DSL Structures (Defined in `dsl` package):**

*   **`Workflow`**: The top-level structure representing the entire workflow definition.
    *   `Variables map[string]string`: Initial variables available to the workflow. These act as the initial state or input.
    *   `Root Statement`: The starting point of the workflow logic (can be a single activity, a sequence, or parallel steps).
*   **`Statement`**: A building block representing a single step or a composite structure. A `Statement` can contain one of the following:
    *   `Activity *ActivityInvocation`: Represents a call to a Temporal Activity.
    *   `Sequence *Sequence`: Represents a series of statements executed sequentially.
    *   `Parallel *Parallel`: Represents a set of statements executed in parallel.
*   **`Sequence`**: Contains a slice `Elements []*Statement` which are executed one after another.
*   **`Parallel`**: Contains a slice `Branches []*Statement` which are executed concurrently. The parallel execution waits for all branches to complete. If one branch errors, others are cancelled.
*   **`ActivityInvocation`**: Defines how to invoke a specific Temporal Activity.
    *   `Name string`: The registered name of the Temporal Activity to call.
    *   `Arguments []string`: A list of variable names (keys from the `bindings` map) whose values should be passed as arguments to the activity.
    *   `Result string`: The name of the variable (key in the `bindings` map) where the activity's result should be stored.

**Execution Flow (`SimpleDSLWorkflow`):**

*   The entry point for workflows defined using this DSL is the `SimpleDSLWorkflow` function: `func SimpleDSLWorkflow(ctx workflow.Context, dslWorkflow Workflow) ([]byte, error)`.
*   It initializes a `bindings` map from the `dslWorkflow.Variables`.
*   It sets default `workflow.ActivityOptions` (e.g., `StartToCloseTimeout`).
*   It uses `workflow.GetLogger(ctx)` for logging.
*   It recursively calls the `execute` method on the `Root` statement, passing the `ctx` and `bindings` map.

**Data Flow (`bindings`):**

*   The `bindings map[string]string` acts as the shared state or memory for the workflow execution.
*   Initial values come from `Workflow.Variables`.
*   `ActivityInvocation.Arguments` specifies which values from `bindings` to use as input for an activity.
*   `ActivityInvocation.Result` specifies the key in `bindings` where the activity's return value should be stored.
*   The `makeInput` helper function retrieves argument values from the `bindings` map based on the names listed in `ActivityInvocation.Arguments`.

**Concurrency (`Parallel` execution):**

*   The `Parallel.execute` method uses `workflow.Go` to launch each branch concurrently.
*   It uses `workflow.NewSelector` and `Future.Get` to wait for branches to complete.
*   `workflow.WithCancel` is used to cancel pending branches if one branch encounters an error.

**Working with the DSL:**

*   When asked to create or modify workflows, structure the logic using the `Workflow`, `Statement`, `Sequence`, `Parallel`, and `ActivityInvocation` types.
*   Define the flow of execution by nesting `Sequence` and `Parallel` structures within `Statement`s.
*   Specify activity calls using `ActivityInvocation`, ensuring `Name`, `Arguments`, and `Result` are correctly defined based on the available activities and the desired data flow through the `bindings` map.
*   Remember that the actual activity implementation exists separately (see `activities.mdc`) and is invoked by name.
```go
package dsl

import (
	"time"

	"go.temporal.io/sdk/workflow"
)

type (
	// Workflow is the type used to express the workflow definition. Variables are a map of valuables. Variables can be
	// used as input to Activity.
	Workflow struct {
		Variables map[string]string
		Root      Statement
	}

	// Statement is the building block of dsl workflow. A Statement can be a simple ActivityInvocation or it
	// could be a Sequence or Parallel.
	Statement struct {
		Activity *ActivityInvocation
		Sequence *Sequence
		Parallel *Parallel
	}

	// Sequence consist of a collection of Statements that runs in sequential.
	Sequence struct {
		Elements []*Statement
	}

	// Parallel can be a collection of Statements that runs in parallel.
	Parallel struct {
		Branches []*Statement
	}

	// ActivityInvocation is used to express invoking an Activity. The Arguments defined expected arguments as input to
	// the Activity, the result specify the name of variable that it will store the result as which can then be used as
	// arguments to subsequent ActivityInvocation.
	ActivityInvocation struct {
		Name      string
		Arguments []string
		Result    string
	}

	executable interface {
		execute(ctx workflow.Context, bindings map[string]string) error
	}
)

// SimpleDSLWorkflow workflow definition
func SimpleDSLWorkflow(ctx workflow.Context, dslWorkflow Workflow) ([]byte, error) {
	bindings := make(map[string]string)
	//workflowcheck:ignore Only iterates for building another map
	for k, v := range dslWorkflow.Variables {
		bindings[k] = v
	}

	ao := workflow.ActivityOptions{
		StartToCloseTimeout: 10 * time.Second,
	}
	ctx = workflow.WithActivityOptions(ctx, ao)
	logger := workflow.GetLogger(ctx)

	err := dslWorkflow.Root.execute(ctx, bindings)
	if err != nil {
		logger.Error("DSL Workflow failed.", "Error", err)
		return nil, err
	}

	logger.Info("DSL Workflow completed.")
	return nil, err
}

func (b *Statement) execute(ctx workflow.Context, bindings map[string]string) error {
	if b.Parallel != nil {
		err := b.Parallel.execute(ctx, bindings)
		if err != nil {
			return err
		}
	}
	if b.Sequence != nil {
		err := b.Sequence.execute(ctx, bindings)
		if err != nil {
			return err
		}
	}
	if b.Activity != nil {
		err := b.Activity.execute(ctx, bindings)
		if err != nil {
			return err
		}
	}
	return nil
}

func (a ActivityInvocation) execute(ctx workflow.Context, bindings map[string]string) error {
	inputParam := makeInput(a.Arguments, bindings)
	var result string
	err := workflow.ExecuteActivity(ctx, a.Name, inputParam).Get(ctx, &result)
	if err != nil {
		return err
	}
	if a.Result != "" {
		bindings[a.Result] = result
	}
	return nil
}

func (s Sequence) execute(ctx workflow.Context, bindings map[string]string) error {
	for _, a := range s.Elements {
		err := a.execute(ctx, bindings)
		if err != nil {
			return err
		}
	}
	return nil
}

func (p Parallel) execute(ctx workflow.Context, bindings map[string]string) error {
	//
	// You can use the context passed in to activity as a way to cancel the activity like standard GO way.
	// Cancelling a parent context will cancel all the derived contexts as well.
	//

	// In the parallel block, we want to execute all of them in parallel and wait for all of them.
	// if one activity fails then we want to cancel all the rest of them as well.
	childCtx, cancelHandler := workflow.WithCancel(ctx)
	selector := workflow.NewSelector(ctx)
	var activityErr error
	for _, s := range p.Branches {
		f := executeAsync(s, childCtx, bindings)
		selector.AddFuture(f, func(f workflow.Future) {
			err := f.Get(ctx, nil)
			if err != nil {
				// cancel all pending activities
				cancelHandler()
				activityErr = err
			}
		})
	}

	for i := 0; i < len(p.Branches); i++ {
		selector.Select(ctx) // this will wait for one branch
		if activityErr != nil {
			return activityErr
		}
	}

	return nil
}

func executeAsync(exe executable, ctx workflow.Context, bindings map[string]string) workflow.Future {
	future, settable := workflow.NewFuture(ctx)
	workflow.Go(ctx, func(ctx workflow.Context) {
		err := exe.execute(ctx, bindings)
		settable.Set(nil, err)
	})
	return future
}

func makeInput(argNames []string, argsMap map[string]string) []string {
	var args []string
	for _, arg := range argNames {
		args = append(args, argsMap[arg])
	}
	return args
}
```

**Example Workflows:**

Here are some example workflow implementations:

* Serial workflow:

```yaml
# This sample workflow execute 3 steps in sequence.
# 1) sampleActivity1, takes arg1 as input, and put result as result1.
# 2) sampleActivity2, takes result1 as input, and put result as result2.
# 3) sampleActivity3, takes args2 and result2 as input, and put result as result3.
variables:
  arg1: value1
  arg2: value2

root:
  sequence:
    elements:
     - activity:
        name: SampleActivity1
        arguments:
          - arg1
        result: result1
     - activity:
        name: SampleActivity2
        arguments:
          - result1
        result: result2
     - activity:
        name: SampleActivity3
        arguments:
          - arg2
          - result2
        result: result3
```

* Parallel workflow:

```yaml
# This sample workflow execute 3 steps in sequence.
# 1) activity1, takes arg1 as input, and put result as result1.
# 2) it runs a parallel block which runs below sequence branches in parallel
#  2.1) sequence 1
#    2.1.1) activity2, takes result1 as input, and put result as result2
#    2.1.2) activity3, takes arg2 and result2 as input, and put result as result3
#  2.2) sequence 2
#    2.2.1) activity4, takes result1 as input, and put result as result4
#    2.2.2) activity5, takes arg3 and result4 as input, and put result as result5
# 3) activity1, takes result3 and result5 as input, and put result as result6.
variables:
  arg1: value1
  arg2: value2
  arg3: value3

root:
  sequence:
    elements:
      - activity:
         name: SampleActivity1
         arguments:
           - arg1
         result: result1
      - parallel:
          branches:
            - sequence:
                elements:
                 - activity:
                    name: SampleActivity2
                    arguments:
                      - result1
                    result: result2
                 - activity:
                    name: SampleActivity3
                    arguments:
                      - arg2
                      - result2
                    result: result3
            - sequence:
                elements:
                 - activity:
                    name: SampleActivity4
                    arguments:
                      - result1
                    result: result4
                 - activity:
                    name: SampleActivity5
                    arguments:
                      - arg3
                      - result4
                    result: result5
      - activity:
         name: SampleActivity1
         arguments:
           - result3
           - result5
         result: result6
```

---
description:
globs:
alwaysApply: false
---
This file provides rules and context for generating or understanding Go code related to Temporal activities within this project with the specific purpose of using a simple DSL to specify workflows.

**Activity Structure and Naming:**

*   Activities should be methods on a struct (e.g., `SampleActivities`).
*   Activity functions must accept `ctx context.Context` as the first argument.
*   Use descriptive names for activities (e.g., `SampleActivity1`, `ProcessOrderActivity`).
*   Follow the typical signature: `func (a *StructName) ActivityName(ctx context.Context, input ArgType) (ResultType, error)`.

**Accessing Activity Info:**

*   Use `activity.GetInfo(ctx)` to retrieve activity metadata like its name.
*   Example: `name := activity.GetInfo(ctx).ActivityType.Name`

**Logging:**

*   You **must** use Temporal `activity.GetLogger(ctx)` for logging within activities.
*   Always include the activity name in log messages for better context.

**Return Values:**

*   Activities must return a result value and an error.
*   Return `nil` for the error upon successful execution.
*   Construct meaningful result values, potentially incorporating information derived during the activity's execution.

**Context Handling:**

*   Ensure the `ctx context.Context` is propagated to any Temporal SDK calls or other functions that require context.

**Best Practices:**

*   Strive to make activities idempotent.
*   Keep activities focused on a single task and relatively short-lived.
*   Avoid embedding complex business logic directly within activities. Orchestrate logic in workflows and utilize activities primarily for side effects or computations.
```go
package dsl

import (
	"context"
	"fmt"

	"go.temporal.io/sdk/activity"
)

type SampleActivities struct {
}

func (a *SampleActivities) SampleActivity1(ctx context.Context, input []string) (string, error) {
	name := activity.GetInfo(ctx).ActivityType.Name
	fmt.Printf("Run %s with input %v \n", name, input)
	return "Result_" + name, nil
}

func (a *SampleActivities) SampleActivity2(ctx context.Context, input []string) (string, error) {
	name := activity.GetInfo(ctx).ActivityType.Name
	fmt.Printf("Run %s with input %v \n", name, input)
	return "Result_" + name, nil
}

func (a *SampleActivities) SampleActivity3(ctx context.Context, input []string) (string, error) {
	name := activity.GetInfo(ctx).ActivityType.Name
	fmt.Printf("Run %s with input %v \n", name, input)
	return "Result_" + name, nil
}

func (a *SampleActivities) SampleActivity4(ctx context.Context, input []string) (string, error) {
	name := activity.GetInfo(ctx).ActivityType.Name
	fmt.Printf("Run %s with input %v \n", name, input)
	return "Result_" + name, nil
}

func (a *SampleActivities) SampleActivity5(ctx context.Context, input []string) (string, error) {
	name := activity.GetInfo(ctx).ActivityType.Name
	fmt.Printf("Run %s with input %v \n", name, input)
	return "Result_" + name, nil
}



`🔄 **Context:** [Agent: Current] | [Skill: go-temporal-dsl-prompt-file] | [Workflow: Current]`
