# Decentralized Childcare Network

A blockchain-based childcare management system built on Stacks using Clarity smart contracts.

## Overview

The Decentralized Childcare Network provides a transparent, secure, and efficient way to manage childcare services through five interconnected smart contracts:

1. **Caregiver Background Verification Contract** - Validates childcare provider safety and credentials
2. **Child Enrollment Contract** - Manages daycare registration and requirements
3. **Daily Activity Reporting Contract** - Tracks child care and development activities
4. **Emergency Contact Contract** - Manages parent notification during incidents
5. **Payment and Subsidy Contract** - Handles childcare fees and government assistance

## Features

### Caregiver Verification
- Background check validation
- Certification tracking
- Safety score management
- Verification status updates

### Child Enrollment
- Registration management
- Age and health requirement validation
- Enrollment status tracking
- Caregiver assignment

### Activity Reporting
- Daily activity logging
- Development milestone tracking
- Parent notification system
- Activity history management

### Emergency Management
- Emergency contact registration
- Incident reporting
- Automated parent notifications
- Emergency response tracking

### Payment Processing
- Fee calculation and collection
- Government subsidy management
- Payment history tracking
- Financial transparency

## Contract Architecture

Each contract operates independently while maintaining data consistency through standardized data structures and validation rules.

### Data Types

- **Caregiver**: Background verification and certification data
- **Child**: Enrollment information and care requirements
- **Activity**: Daily care activities and milestones
- **Emergency**: Contact information and incident reports
- **Payment**: Fee structures and subsidy calculations

## Getting Started

### Prerequisites

- Clarinet CLI
- Node.js 18+
- Stacks wallet for testing

### Installation

\`\`\`bash
npm install
clarinet check
\`\`\`

### Testing

\`\`\`bash
npm test
\`\`\`

### Deployment

\`\`\`bash
clarinet deploy --testnet
\`\`\`

## Usage Examples

### Register a Caregiver

\`\`\`clarity
(contract-call? .caregiver-verification register-caregiver
"Jane Smith"
"Certified Childcare Provider"
u95)
\`\`\`

### Enroll a Child

\`\`\`clarity
(contract-call? .child-enrollment enroll-child
"Tommy Johnson"
u3
"No allergies"
tx-sender)
\`\`\`

### Log Daily Activity

\`\`\`clarity
(contract-call? .daily-activity-reporting log-activity
u1
"Outdoor play and learning activities"
u8)
\`\`\`

## Security Considerations

- All contracts include proper access controls
- Input validation prevents malicious data entry
- Emergency procedures ensure child safety
- Financial transactions are transparent and auditable

## Contributing

Please read our contributing guidelines and submit pull requests for any improvements.

## License

MIT License - see LICENSE file for details.
