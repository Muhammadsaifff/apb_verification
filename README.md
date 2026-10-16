# APB Protocol Verification Suite (UVM) 🚌🛡️

An advanced, reusable hardware verification architecture designed in **SystemVerilog** utilizing the **Universal Verification Methodology (UVM)** to validate compliance, protocol constraints, and functionality of an **Advanced Peripheral Bus (APB)** master/slave infrastructure.

---

## 📁 Repository Structure

The architecture conforms to standardized UVM component guidelines:

```text
├── apb_slave.sv       # Design Under Test (DUT) - APB Peripheral Slave responder
├── tb_top.sv          # Top-level module (instantiates clock, DUT, and interfaces)
├── apb_if.sv          # APB Protocol SystemVerilog Interface (PCLK, PADDR, PWDATA, etc.)
├── apb_package.sv     # SystemVerilog package grouping all verification elements
├── apb_transaction.sv # UVM Sequence Item representing APB Read/Write transactions
├── apb_sequence.sv    # UVM Sequences defining random or directed transaction blocks
├── apb_sequencer.sv   # UVM Sequencer routing transactions from sequences to driver
├── apb_driver.sv      # UVM Driver executing the APB bus state machine cycles
├── apb_monitor.sv     # UVM Monitor sniffing signals off the virtual interface
├── apb_agent.sv       # UVM Agent encapsulating sequencer, driver, and monitor layers
├── apb_env.sv         # UVM Environment binding agents and evaluation elements
├── apb_scoreboard.sv  # UVM Scoreboard evaluating expected vs. actual transactional outcomes
├── apb_test.sv        # UVM Test containing initialization parameters and runtime tasks
└── run.do             # ModelSim/QuestaSim automated automation layout script
```

---

## ✨ Features

* **Complete APB Bus Implementation:** Verifies key protocol lifecycle phases including **Setup**, **Access**, and **Idle** operational loops.
* **Closed-Loop Verification:** Integrates a custom **UVM Scoreboard** (`apb_scoreboard.sv`) verifying data integrity on memory write and read matching tracking.
* **Constrained-Random Generation:** Dynamic transaction parameter generation matching APB bus address space and data byte limits.
* **Turnkey EDA Automation:** Pre-configured simulation run script (`run.do`) ensuring one-click compilation and waveform deployment.

---

## 🛠️ Tooling & Requirements

An EDA simulator capable of compiling IEEE 1800 SystemVerilog along with structural UVM-1.1/1.2 class definitions is required:
* **Siemens EDA / Mentor Graphics:** QuestaSim / ModelSim
* **Synopsys:** VCS
* **Cadence:** Xcelium / Incisive

---

## 🚀 Getting Started

### 1. Project Workspace Cloned
Clone the verification environment directory onto your target machine:
```bash
git clone https://github.com
cd apb_verification
```

### 2. Execution Setup (ModelSim / QuestaSim)
To run all phases of compilation, loading, and active waveform analysis, trigger the execution script from your simulator-integrated CLI terminal console:

```bash
vsim -c -do run.do
```

*If executing interactively inside an open ModelSim/QuestaSim GUI environment desktop tool, input:*
```tcl
do run.do
```

### 3. Testbench Component Connectivity Loop
1. **`tb_top`** boots the base system clock, shapes global resets, and anchors `apb_if` pins cleanly to the inputs/outputs of `apb_slave.sv`.
2. The interface hook gets wrapped into an internal database registry container block via `uvm_config_db`.
3. **`apb_test`** constructs the primary simulation test layers, triggers `apb_env`, and sets sequential read/write transactional constraints loose through the active sequencer pipeline.

---

## 🤝 Contributing

Contributions to test alternative edge cases like wait states (`PREADY` delays) or multi-slave switching schemes are appreciated.
1. Fork the Project Repository
2. Create your Feature Branch (`git checkout -b feature/ApbExtension`)
3. Commit your Extensions (`git commit -m 'Add PREADY check assertions'`)
4. Push to the Branch (`git push origin feature/ApbExtension`)
5. Open a Pull Request

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more details.
