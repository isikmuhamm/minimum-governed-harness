// ContextRail: TASK-0001
// Invariant: Read-only handling does not modify specification state.
export function canMutateSpecification(readOnly: boolean): boolean {
  return !readOnly;
}
