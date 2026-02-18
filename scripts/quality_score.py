#!/usr/bin/env python3
# ==============================================================================
# Quality Scoring for Quarto Slides
# ==============================================================================
# Scoring rubric based on .claude/rules/quality-gates.md
# ==============================================================================

import re
import sys
import os
from pathlib import Path

def score_quarto_slide(filepath):
    """Score a Quarto slide file based on quality gates."""
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    score = 100
    issues = []
    
    lines = content.split('\n')
    
    # Check for long lines (>100 chars, excluding math formulas)
    for i, line in enumerate(lines, 1):
        if len(line) > 100:
            # Check if it's a math formula (contains $$ or \[ or \()
            if not any(pattern in line for pattern in ['$$', '\\[', '\\(', '\\begin{', '\\end{']):
                issues.append(f"Line {i}: Long line ({len(line)} chars)")
                score -= 1
    
    # Check for basic HTML structure
    if not '<!DOCTYPE html>' in content:
        issues.append("Missing DOCTYPE declaration")
        score -= 5
    
    if '<title>' not in content:
        issues.append("Missing title tag")
        score -= 5
    
    # Check for math rendering method
    if 'mathjax' not in content.lower():
        issues.append("MathJax not configured (math may not render)")
        score -= 10
    
    # Check for broken citations (@cite without closing})
    broken_citations = re.findall(r'@[\w\-\_]+[^\}]*$', content, re.MULTILINE)
    for cite in broken_citations:
        issues.append(f"Possible broken citation: {cite}")
        score -= 5
    
    # Check for basic YAML frontmatter
    if not content.startswith('---'):
        issues.append("Missing YAML frontmatter")
        score -= 10
    else:
        # Check for required YAML fields
        if 'title:' not in content.split('---')[1]:
            issues.append("Missing title in YAML frontmatter")
            score -= 5
    
    # Ensure score doesn't go below 0
    score = max(0, score)
    
    return score, issues

def main():
    if len(sys.argv) < 2:
        print("Usage: python quality_score.py <quarto_file.qmd>")
        sys.exit(1)
    
    filepath = sys.argv[1]
    
    if not os.path.exists(filepath):
        print(f"Error: File not found: {filepath}")
        sys.exit(1)
    
    score, issues = score_quarto_slide(filepath)
    
    print(f"\n{'='*60}")
    print(f"Quality Score: {score}/100")
    print(f"{'='*60}")
    
    if score >= 90:
        print("Status: ✅ EXCELLENT - Ready for PR")
    elif score >= 80:
        print("Status: ✅ GOOD - Ready to commit")
    elif score >= 60:
        print("Status: ⚠️  NEEDS WORK - Fix blocking issues")
    else:
        print("Status: ❌ POOR - Major revisions needed")
    
    print(f"\nIssues Found: {len(issues)}")
    if issues:
        print("\nDetails:")
        for issue in issues:
            print(f"  - {issue}")
    else:
        print("\nNo issues found! Great job!")
    
    print(f"\n{'='*60}")

if __name__ == '__main__':
    main()
